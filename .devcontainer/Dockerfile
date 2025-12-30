ARG BASE_IMAGE=docker.io/library/python:3.14.2-slim
FROM $BASE_IMAGE

# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.source "https://github.com/dbrennand/home-ops/blob/main/.devcontainer/Dockerfile"
LABEL org.opencontainers.image.authors "Daniel Brennand"
LABEL org.opencontainers.image.licenses "MIT"
LABEL org.opencontainers.image.base.name $BASE_IMAGE
LABEL org.opencontainers.image.title "home-ops"
LABEL org.opencontainers.image.description "home-ops VSCode Dev Container"

# Tooling
RUN apt update && \
    apt -y install git \
    openssh-client \
    locales-all

# uv
COPY --from=ghcr.io/astral-sh/uv:0.9.21 /uv /uvx /bin/

# OpenTofu
COPY --from=ghcr.io/opentofu/opentofu:1.11.1 /usr/local/bin/tofu /bin/tofu
