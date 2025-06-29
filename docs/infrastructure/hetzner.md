# :simple-hetzner: Hetzner Cloud

[Hetzner Cloud](https://www.hetzner.com/cloud) is a European based public cloud provider. Based in Germany, they also have datacenters in Finland, USA and Singapore.

## :material-server: Cloud VPS

I have a single cloud VPS provisioned on Hetzner. The VPS is deployed using [OpenTofu](https://github.com/dbrennand/home-ops/blob/dev/terraform/hetzner.tf) using the method documented [here](./opentofu.md).

I'm currently using this VPS as a remote monitoring host by running [Beszel](./beszel.md) to monitor all my Homelab devices over Tailscale.
