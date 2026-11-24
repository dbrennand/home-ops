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

The playbook creates a Hetzner Cloud firewall. SSH is restricted to the
Ansible control host's public IP, resolved each time the playbook runs. The
Pangolin ports and their purposes are listed on the [Pangolin
page](pangolin.md).

The [architecture overview](architecture.md) shows how this VPS fits alongside
the home network.
