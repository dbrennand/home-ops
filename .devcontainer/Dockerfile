ARG BASE_IMAGE=ghcr.io/ansible/creator-ee:v24.2.0
FROM $BASE_IMAGE

# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.source "https://github.com/dbrennand/home-ops/blob/dev/.devcontainer/Dockerfile"
LABEL org.opencontainers.image.authors "Daniel Brennand"
LABEL org.opencontainers.image.licenses "MIT"
LABEL org.opencontainers.image.base.name $BASE_IMAGE
LABEL org.opencontainers.image.title "home-ops"
LABEL org.opencontainers.image.description "home-ops VSCode Dev Container"

# mkdocs-material
RUN pip install mkdocs-material==9.5.9

# Terraform
COPY --from=docker.io/hashicorp/terraform:1.7.3 /bin/terraform /usr/bin/terraform
