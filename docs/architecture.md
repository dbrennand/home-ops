# :material-lan: Home and Cloud Network Architecture

This diagram shows the home network, its NextDNS and Tailscale integrations,
and the Hetzner Cloud VPS intended to host Pangolin.

```mermaid
flowchart LR
    remote["Remote device"] -->|Encrypted tunnel| tailscale["Tailscale tailnet"]
    remote -->|Remote access| pangolin

    subgraph cloud["Hetzner Cloud"]
        vps["ubuntu01.hetzner.dbren.uk<br/>Ubuntu 26.04"]
        pangolin["Pangolin<br/>remote access gateway"]
        vps --- pangolin
    end

    subgraph home["Home network · 192.168.0.0/24"]
        router["Home router<br/>192.168.0.1"]
        pi01["pi01.net.dbren.uk<br/>192.168.0.2"]
        pi02["pi02.net.dbren.uk<br/>192.168.0.3"]
        site["Pangolin site connector<br/>(managed outside this repo)"]

        router --- pi01
        router --- pi02
        router --- site
    end

    pi01 -->|DNS queries| nextdns["NextDNS<br/>45.90.28.138<br/>45.90.30.138"]
    pi02 -->|DNS queries| nextdns
    nextdns --> internet["Internet"]

    tailscale -->|Remote access| pi01
    tailscale -->|Remote access| pi02
    pangolin -.->|Encrypted site tunnel| site
```

See the [DNS documentation](dns.md) for details about NextDNS and its rewrite
records. [Tailscale](tailscale.md) provides encrypted remote access to the
Raspberry Pi devices from outside the home network.

The [Hetzner VPS](hetzner-vps.md) is the intended public host for
[Pangolin](pangolin.md), which provides access to selected services on remote
networks. The dotted connection shows the intended site tunnel; the site
connector and resource configuration are managed outside this repository.
