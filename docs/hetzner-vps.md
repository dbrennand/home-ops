# Hetzner Cloud VPS

The `ubuntu01.hetzner.dbren.uk` VPS runs Ubuntu 26.04 on Hetzner Cloud. It is
intended to host [Pangolin](pangolin.md), the public remote access gateway for
reaching selected services on my home network.

The [`hetzner_vps_playbook.yml`](https://github.com/dbrennand/home-ops/blob/devel/hetzner_vps_playbook.yml)
Ansible playbook provisions the server in the `fsn1` location using the
`cax11` server type. Cloud-init creates the `daniel` account, adds public SSH
keys from GitHub, disables password and root SSH login, and sets the timezone
to Europe/London.

## Firewall

The playbook creates a Hetzner Cloud firewall for Pangolin and SSH:

| Protocol | Port | Source | Purpose |
| --- | ---: | --- | --- |
| TCP | 22 | Ansible control host public IP | SSH administration |
| TCP | 80 | Any IPv4 or IPv6 address | HTTP and certificate validation |
| TCP | 443 | Any IPv4 or IPv6 address | HTTPS |
| UDP | 51820 | Any IPv4 or IPv6 address | Pangolin site tunnels |
| UDP | 21820 | Any IPv4 or IPv6 address | Pangolin client tunnels |

The playbook resolves the control host's public IP when it runs and uses that
address as the SSH allowlist. The other ports support the Pangolin deployment;
see the [Pangolin page](pangolin.md) for details and configuration ownership.

The [architecture overview](architecture.md) shows how this VPS fits alongside
the home network.
