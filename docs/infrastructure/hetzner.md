# :simple-hetzner: Hetzner Cloud

[Hetzner Cloud](https://www.hetzner.com/cloud) is a European based public cloud provider. Based in Germany, they also have datacenters in Finland, USA and Singapore.

## :material-server: Cloud VPS

I have a single cloud VPS provisioned on Hetzner. The VPS is deployed using [OpenTofu](https://github.com/dbrennand/home-ops/blob/main/terraform/hetzner.tf) using the method documented [here](./opentofu.md).

I'm currently using this VPS for:

- Remotely monitoring via Tailscale all my Homelab devices using [Beszel](./beszel.md).
- Hosting a [status](https://status.macaroni-beardie.ts.net/) page using [Tailscale Funnel](https://tailscale.com/kb/1223/funnel). All devices are accessed remotely via Tailscale.
