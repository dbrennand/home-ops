<!--# cspell: ignore SSOT CMDB -->
# AGENTS.md

Ensure that all practices and instructions described by
<https://raw.githubusercontent.com/ansible/ansible-creator/refs/heads/main/docs/agents.md>
are followed.

## Pre-commit Hooks

This repository uses [prek](https://github.com/j178/prek) as its Git hook
manager. Hook checks run automatically on every commit via the installed Git
shims.

- Hook configuration lives in `prek.toml` at the repository root.
- The configured checks are `ansible-lint`, `end-of-file-fixer`, and
  `mixed-line-ending` (LF line endings).
- Run all checks on demand with `uv run prek run --all-files`.
- Reinstall the Git hook shims after cloning with `uv run prek install -f`.

## Commit Convention

All commits in this repository must follow the
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard,
using the `type(scope): description` format (for example,
`feat(role): add podman container role`).
