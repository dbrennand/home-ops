# :simple-tailscale: Tailscale

!!! quote "What is Tailscale?"

    [Tailscale](https://tailscale.com/) is a VPN service that makes the devices and applications you own accessible anywhere in the world, securely and effortlessly. It enables encrypted point-to-point connections using the open source WireGuard protocol, which means only devices on your private network can communicate with each other.

Tailscale is used in my Homelab to remotely access services. I've written a little more about this [here](https://danielbrennand.com/blog/tailscale/).

An [Ansible playbook](https://github.com/dbrennand/home-ops/blob/main/ansible/playbooks/playbook-tailscale.yml) is used to install and configure Tailscale on all devices in my Homelab. The configuration for each device is managed via Ansible [group](https://github.com/dbrennand/home-ops/tree/main/ansible/inventory/group_vars) and [host](https://github.com/dbrennand/home-ops/tree/main/ansible/inventory/host_vars) vars.

## Tailscale OAuth Client

For devices to authenticate to the Tailnet an [OAuth client](https://login.tailscale.com/admin/settings/oauth) is required.

## DNS

My Tailnet is configured to use [NextDNS](./dns.md) as the upstream DNS provider. This blocks trackers and ads as well as provide DNS resolution for my Homelab without the maintenance overhead of maintaining my own DNS server.
