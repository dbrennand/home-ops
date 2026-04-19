#!/usr/bin/env python3
"""
Build ansible/ee/requirements.txt from Ansible collection Python dependencies.

Usage:
    uv run python ansible/ee/build_requirements.py

Steps:
  1. Install Ansible collections from requirements.yml via ansible-galaxy.
  2. Introspect installed collections to discover their Python requirements
     (ansible-builder introspect) -> writes collection-requirements.txt.
  3. Resolve the full dependency tree with uv pip compile, annotating each
     package with the collection(s) that introduced it.
  4. Write the result to ansible/ee/requirements.txt.

Prerequisites: uv sync --group build  (installs ansible-builder)
"""

import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

EE_DIR = Path(__file__).parent
COLLECTIONS_DIR = EE_DIR / "ansible_collections"
COLLECTION_REQS_FILE = EE_DIR / "collection-requirements.txt"
OUTPUT_FILE = EE_DIR / "requirements.txt"


# ---------------------------------------------------------------------------
# Shell helpers
# ---------------------------------------------------------------------------


def run(cmd: list[str]) -> str:
    """Run *cmd*, exit on non-zero return code, return stdout."""
    print(f"+ {' '.join(str(c) for c in cmd)}")
    proc = subprocess.run(cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        sys.stdout.write(proc.stdout)
        sys.stderr.write(proc.stderr)
        sys.exit(proc.returncode)
    return proc.stdout


# ---------------------------------------------------------------------------
# Pipeline steps
# ---------------------------------------------------------------------------


def install_collections() -> None:
    print("\n==> Installing Ansible collections...")
    run([
        "uv", "--directory", str(EE_DIR), "run",
        "ansible-galaxy", "collection", "install",
        "-r", "requirements.yml",
        "-p", "ansible_collections",
        "--force",
    ])


def introspect_collections() -> None:
    print("\n==> Introspecting collections for Python requirements...")
    run([
        "uv", "--directory", str(EE_DIR), "run",
        "ansible-builder", "introspect", ".",
        "--write-pip", "collection-requirements.txt",
        "--write-bindep", "bindep.txt",
    ])


def build_collection_package_map() -> dict[str, list[str]]:
    """
    Scan each collection's top-level requirements.txt and return
    {normalized_pkg_name: [collection, ...]} so we can annotate which
    collection(s) introduced each direct dependency.
    """
    pkg_map: dict[str, set[str]] = defaultdict(set)

    for req_file in sorted(COLLECTIONS_DIR.glob("*/*/requirements.txt")):
        rel = req_file.relative_to(COLLECTIONS_DIR)
        # Exactly namespace/name/requirements.txt — skip tests/* etc.
        if len(rel.parts) != 3:
            continue
        namespace, name, _ = rel.parts
        collection = f"{namespace}.{name}"

        for raw in req_file.read_text().splitlines():
            line = raw.strip()
            if not line or line.startswith("#"):
                continue
            key = _pkg_key(line)
            if key:
                pkg_map[key].add(collection)

    return {k: sorted(v) for k, v in pkg_map.items()}


def resolve_with_uv_pip_compile() -> str:
    """Run uv pip compile on collection-requirements.txt; return stdout."""
    print("\n==> Resolving dependencies with uv pip compile...")
    if not COLLECTION_REQS_FILE.exists() or not COLLECTION_REQS_FILE.read_text().strip():
        print("  (no collection Python requirements found)")
        return ""
    return run([
        "uv", "pip", "compile",
        "--annotation-style=split",
        "--no-header",
        str(COLLECTION_REQS_FILE),
    ])


# ---------------------------------------------------------------------------
# Output rendering
# ---------------------------------------------------------------------------


def _pkg_key(spec: str) -> str:
    """Normalise a package specifier to a bare, lowercase name (- -> _)."""
    return re.split(r"[=!<>\[\s;@~]", spec.strip())[0].lower().replace("-", "_")


def _parse_via(via_lines: list[str]) -> list[str]:
    """
    Extract individual ref strings from a via annotation block.

    Handles both forms emitted by uv pip compile --annotation-style=split:

        # single ref:   "    # via some-package"
        # multi ref:    "    # via"
        #               "    #   package-a"
        #               "    #   package-b"
    """
    refs: list[str] = []
    j = 0
    while j < len(via_lines):
        vl = via_lines[j]
        if re.match(r"^\s+#\s+via\s*$", vl):          # "    # via" header
            j += 1
            while j < len(via_lines):
                refs.append(re.sub(r"^\s+#\s+", "", via_lines[j]))
                j += 1
        elif m := re.match(r"^\s+#\s+via\s+(.+)$", vl):  # "    # via ref"
            refs.append(m.group(1))
            j += 1
        else:
            j += 1
    return refs


def _render_block(pkg_line: str, refs: list[str]) -> str:
    """Render one package specifier with its (possibly empty) via annotations."""
    if not refs:
        return pkg_line
    parts = [pkg_line]
    if len(refs) == 1:
        parts.append(f"    # via {refs[0]}")
    else:
        parts.append("    # via")
        for ref in refs:
            parts.append(f"    #   {ref}")
    return "\n".join(parts)


def render_requirements(compiled: str, pkg_map: dict[str, list[str]]) -> str:
    """
    Post-process uv pip compile output.

    For each resolved package:
    - Transitive deps keep their existing "# via <package>" annotations.
    - Direct deps (those annotated "# via -r collection-requirements.txt")
      have their generic file-reference replaced with the collection name(s)
      that declared the package, e.g. "awx.awx (collection)".
    """
    header = (
        "# This file is generated by ansible/ee/build_requirements.py\n"
        "# DO NOT EDIT — run `python ansible/ee/build_requirements.py` to regenerate\n"
    )

    if not compiled.strip():
        return header + "\n"

    result: list[str] = []
    lines = compiled.split("\n")
    i = 0

    while i < len(lines):
        line = lines[i]

        if not line.strip():        # blank line between blocks — skip, re-add later
            i += 1
            continue

        if line.startswith("#"):    # top-level comment — pass through
            result.append(line)
            i += 1
            continue

        if not line[0].isspace():   # package specifier line
            pkg = _pkg_key(line)

            # Gather subsequent annotation lines
            via_lines: list[str] = []
            i += 1
            while i < len(lines) and lines[i].startswith("    #"):
                via_lines.append(lines[i])
                i += 1

            refs = _parse_via(via_lines)
            direct = [r for r in refs if r.startswith("-r ")]
            transitive = [r for r in refs if not r.startswith("-r ")]

            new_refs: list[str] = list(transitive)
            if direct:
                colls = pkg_map.get(pkg, [])
                if colls:
                    new_refs.extend(f"{c} (collection)" for c in colls)
                else:
                    # Fallback: keep the original -r annotation
                    new_refs.extend(direct)

            result.append(_render_block(line, new_refs))

        else:                       # indented non-annotation line (shouldn't occur)
            result.append(line)
            i += 1

    return header + "\n" + "\n\n".join(result) + "\n"


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


def main() -> None:
    install_collections()
    introspect_collections()

    pkg_map = build_collection_package_map()
    compiled = resolve_with_uv_pip_compile()
    output = render_requirements(compiled, pkg_map)

    OUTPUT_FILE.write_text(output)
    COLLECTION_REQS_FILE.unlink(missing_ok=True)
    print(f"\n==> Written to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
