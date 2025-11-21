# :material-dns-outline: DNS

[NextDNS](https://nextdns.io/) is the upstream DNS provider in my Homelab.

!!! quote "What is NextDNS?"

    NextDNS protects you from all kinds of security threats, blocks ads and trackers on websites and in apps.

## Rewrites (A Records)

NextDNS has a rewrites feature which allows me to create DNS A records for my Homelab. I manage these rewrite records via the NextDNS REST API using a script I created called [NextDNS-Rewrites](https://github.com/dbrennand/NextDNS-Rewrites). My configuration file is located [here](https://github.com/dbrennand/home-ops/blob/main/nextdns-config.yml).
