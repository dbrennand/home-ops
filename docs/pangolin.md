# Pangolin

[Pangolin](https://pangolin.net/) is a self-hosted remote access platform. I
intend to use it as the public entry point for reaching selected services on
my home network without exposing each service directly to the internet. The
Pangolin server is intended to run on my [Hetzner Cloud VPS](hetzner-vps.md).

Pangolin connects remote networks to its server through site connectors, then
routes access to resources that an administrator has configured. Resources
can be public, such as a web application behind a proxy, or private, where the
user connects with a Pangolin client. See the official documentation for
[how Pangolin works](https://docs.pangolin.net/about/how-pangolin-works) and
[resource types](https://docs.pangolin.net/manage/resources/understanding-resources).

## Network access

The Hetzner firewall created by
[`hetzner_vps_playbook.yml`](https://github.com/dbrennand/home-ops/blob/devel/hetzner_vps_playbook.yml)
allows the ports used by a self-hosted Pangolin installation:

| Protocol | Port | Purpose |
| --- | ---: | --- |
| TCP | 80 | HTTP and certificate validation |
| TCP | 443 | HTTPS and Pangolin web access |
| UDP | 51820 | Tunnels from Pangolin site connectors |
| UDP | 21820 | Client tunnel traffic |

SSH on TCP port 22 is restricted to the public IP address of the Ansible
control host when the provisioning playbook runs. The Pangolin ports are open
to the internet. For details, see Pangolin's
[self-hosted DNS and networking guide](https://docs.pangolin.net/self-host/dns-and-networking).

## Configuration ownership

This repository provisions the VPS and its Hetzner firewall. It does not
install or configure Pangolin, manage its DNS records, or define site
connectors and resources. Those settings must be maintained in the Pangolin
deployment itself. The intended network relationship is shown in the
[architecture overview](architecture.md).
