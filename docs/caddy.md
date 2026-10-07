# Caddy

Caddy provides HTTPS for internal services and routes requests to their
containers over the shared Docker network named `caddy`.

## Stirling PDF

Caddy accepts HTTPS on ports 443/TCP and 443/UDP and proxies
`stirling.net.dbren.uk` to Stirling PDF on port 8080. Home clients resolve the
hostname to `192.168.0.2`.

Caddy obtains and renews certificates with a Cloudflare DNS-01 challenge. This
keeps the service available over HTTPS.

## Persistent data

Caddy's files are stored under `/opt/compose/caddy` on `pi01`:

| Path             | Contents                                            |
| ---------------- | --------------------------------------------------- |
| `conf/Caddyfile` | Caddy base configuration and Cloudflare TLS snippet |
| `data`           | Certificates and runtime data                       |
| `config`         | Caddy configuration state                           |

The Caddyfile is maintained in this repository.

## Secrets

Caddy's Cloudflare DNS challenge uses credentials managed as described on the
[Secrets Management](secrets-management.md) page.

## Deployment

The Ansible deployment is defined in
[`stirling_pdf_playbook.yml`](https://github.com/dbrennand/home-ops/blob/devel/stirling_pdf_playbook.yml)
and the `dbrennand.home_ops.caddy` and `dbrennand.home_ops.stirling_pdf` roles.
The services have not yet been deployed to `pi01`.
