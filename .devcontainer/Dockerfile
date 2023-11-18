ARG BASE_IMAGE=ghcr.io/ansible/creator-ee:v0.21.0
FROM $BASE_IMAGE

# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.source "https://github.com/dbrennand/home-ops/blob/dev/.devcontainer/Dockerfile"
LABEL org.opencontainers.image.authors "Daniel Brennand"
LABEL org.opencontainers.image.licenses "MIT"
LABEL org.opencontainers.image.base.name $BASE_IMAGE
LABEL org.opencontainers.image.title "home-ops"
LABEL org.opencontainers.image.description "home-ops VSCode Dev Container"

# Install mkdocs-material
RUN pip install mkdocs-material==9.4.9

# Install Go
RUN curl -OL https://go.dev/dl/go1.21.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install Terraform
RUN microdnf install -y yum-utils && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
    microdnf -y install terraform
