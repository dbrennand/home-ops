# :material-dns-outline: DNS

[NextDNS](https://nextdns.io/) is the upstream DNS provider in my
Homelab.

!!! quote "What is NextDNS?"

    NextDNS protects you from all kinds of security threats, blocks ads and
    trackers on websites and in apps.

## Rewrites (A Records)

NextDNS rewrites provide DNS records for services in my Homelab. I manage them
with [`ndrw`](https://github.com/dbrennand/NextDNS-Rewrites), a CLI that
synchronises a YAML configuration file with a selected NextDNS profile through
the NextDNS API. The desired records are defined in
[`nextdns-config.yml`](https://github.com/dbrennand/home-ops/blob/devel/nextdns-config.yml).

See the [`ndrw` README](https://github.com/dbrennand/NextDNS-Rewrites#readme)
for installation instructions and quick-start usage. I run it from the repository
root with `nextdns-config.yml`.

The CLI creates missing configured rewrites and replaces existing rewrites
with the configured values. Rewrites in NextDNS that are absent from the file
are preserved unless `--prune` is supplied. Use `--dry-run` to preview changes;
review prune deletions with `ndrw --config nextdns-config.yml --prune --dry-run`
before applying them.
