# Flux

[FluxCD](https://fluxcd.io/) is deployed on my [Talos](./talos.md) Kubernetes node to adopt a [GitOps](https://fluxcd.io/flux/concepts/#gitops) approach to deploying applications on Kubernetes. My [GitHub repository](https://github.com/dbrennand/home-ops/tree/main/kubernetes) is the source of truth for Kubernetes applications I have deployed.

!!! quote "What is GitOps?"

    GitOps is a way of managing your infrastructure and applications so that whole system is described declaratively and version controlled (most likely in a Git repository), and having an automated process that ensures that the deployed environment matches the state specified in a repository.

    [Source](https://fluxcd.io/flux/concepts/#gitops).

## Prerequisite

Install the [`flux`](https://fluxcd.io/flux/installation/#install-the-flux-cli) CLI:

```bash
brew install fluxcd/tap/flux
```

## Deploying the Flux Controllers

!!! abstract

    [Reference Documentation - GitHub PAT](https://fluxcd.io/flux/installation/bootstrap/github/#github-pat).
    [Reference Documentation - GitHub Personal Account](https://fluxcd.io/flux/installation/bootstrap/github/#github-personal-account).

1. Export the GitHub PAT:

    ```bash
    export GITHUB_TOKEN=<Insert token here>
    ```

2. Deploy the Flux controllers:

    ```bash
    flux bootstrap github \
        --token-auth \
        --owner=dbrennand \
        --repository=home-ops \
        --branch=main \
        --path=kubernetes/flux \
        --personal
    ```

3. Verify that the Flux controllers are reconciled and deployed successfully:

    ```bash
    flux check
    ```
