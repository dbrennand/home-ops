# AGENTS.md

Ensure that all practices and instructions described by
<https://raw.githubusercontent.com/ansible/ansible-creator/refs/heads/main/docs/agents.md>
are followed.

## Pre-commit Hooks

This repository uses [prek](https://github.com/j178/prek) as its Git hook
manager. Hook checks run automatically on every commit via the installed Git
shims.

- Hook configuration and the configured checks live in `prek.toml` at the
  repository root.
- Run all checks on demand with `uv run prek run --all-files`.
- Reinstall the Git hook shims after cloning with `uv run prek install -f`.

## Documentation

Project documentation is built with [Zensical](https://zensical.org/docs/).

- Documentation sources live in `docs/`.
- Site configuration lives in `zensical.toml`.
- Zensical is managed in the dedicated `docs` dependency group.
- Preview the site with `uv run --group docs zensical serve`.
- Build the site with `uv run --group docs zensical build`.

## Commit Convention

All commits in this repository must follow the
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard,
using the `type(scope): description` format (for example,
`feat(role): add podman container role`).
