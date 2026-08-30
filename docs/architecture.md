# :material-lan: Home Network Architecture

This diagram shows the current home network, including its NextDNS and
Tailscale integrations.

```mermaid
flowchart LR
    remote["Remote device"] -->|Encrypted tunnel| tailscale["Tailscale tailnet"]

    subgraph home["Home network · 192.168.0.0/24"]
        router["Home router<br/>192.168.0.1"]
        pi01["pi01.net.dbren.uk<br/>192.168.0.2"]
        pi02["pi02.net.dbren.uk<br/>192.168.0.3"]

        router --- pi01
        router --- pi02
    end

    pi01 -->|DNS queries| nextdns["NextDNS<br/>45.90.28.138<br/>45.90.30.138"]
    pi02 -->|DNS queries| nextdns
    nextdns --> internet["Internet"]

    tailscale -->|Remote access| pi01
    tailscale -->|Remote access| pi02
```

See the [DNS documentation](dns.md) for details about NextDNS and its rewrite
records. Tailscale provides encrypted remote access to the Raspberry Pi
devices from outside the home network.
