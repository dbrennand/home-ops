---
name: pin-workflows
description: Audits all .github/workflows/ action references, upgrades any that are behind the latest release, and pins every tag to its exact SHA commit hash for supply chain security.
---

For every `uses:` line in every file under `.github/workflows/`:

1. If the action reference uses a floating tag (e.g. `@v3`, `@v4`, `@v6`) rather than a full SHA commit hash, it must be pinned.
2. For each action that needs pinning:
   a. Use `gh api repos/{owner}/{repo}/releases/latest` to find the latest release tag.
   b. If the currently used major version is behind the latest, upgrade to the latest release tag.
   c. Use `gh api repos/{owner}/{repo}/git/ref/tags/{tag}` to resolve the tag to its commit SHA.
   d. Replace the floating tag reference with the commit SHA and append the version as a comment, e.g. `uses: actions/checkout@abc1234... # v6.0.2`.
3. Leave any reference that is already pinned to a full SHA alone unless its version is outdated — in that case resolve the latest tag's SHA and update both the SHA and the comment.
4. After all files are processed, print a summary table of every change made (action, old ref, new ref).
