# Docker Compose

[Docker Compose](https://docs.docker.com/compose/) is used to deploy certain applications in my Homelab. The [docker](https://github.com/dbrennand/home-ops/tree/dev/docker) directory contains subdirectories for each application.

## Environment Variables

Each directory contains a `.env` file which references secrets from a 1Password Vault. On the Docker host, the [`op`](https://developer.1password.com/docs/cli/get-started/) CLI is configured to authenticate with a 1Password Service Account. The secret references are then substituted at runtime when using the `op run` command.

## Deployment

!!! info

    The example commands below are for Caddy, but the process is identical for the other application directories.

1. Copy the application directory to the Docker host:

    ```bash
    scp -r caddy daniel@pihole02.net.dbren.uk:~/
    ```

2. SSH to the Docker host:

    ```bash
    ssh daniel@pihole02.net.dbren.uk
    ```

3. Deploy the application:

    ```bash
    cd caddy && op run -- docker compose up -d
    ```
