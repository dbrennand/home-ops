ARG BASE_IMAGE=ghcr.io/ansible/community-ansible-dev-tools:v25.2.1
FROM $BASE_IMAGE

# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.source "https://github.com/dbrennand/home-ops/blob/dev/.devcontainer/Dockerfile"
LABEL org.opencontainers.image.authors "Daniel Brennand"
LABEL org.opencontainers.image.licenses "MIT"
LABEL org.opencontainers.image.base.name $BASE_IMAGE
LABEL org.opencontainers.image.title "home-ops"
LABEL org.opencontainers.image.description "home-ops VSCode Dev Container"

# mkdocs-material
RUN pip install mkdocs-material==9.5.24

# OpenTofu
COPY --from=ghcr.io/opentofu/opentofu:1.9.0 /usr/local/bin/tofu /usr/local/bin/tofu
