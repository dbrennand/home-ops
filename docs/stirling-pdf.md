# Stirling PDF

Stirling PDF is hosted at
[`stirling.net.dbren.uk`](https://stirling.net.dbren.uk). Home clients resolve
this URL to `pi01.net.dbren.uk` (`192.168.0.2`). Caddy provides HTTPS and
proxies requests to Stirling over the shared Docker network. See the [Caddy
documentation](caddy.md) for proxy and TLS details.

The service is internal-only and login is disabled. Anyone on the home network
who can reach it can use its PDF functions.

## Persistent data

Stirling's settings and application data are stored at `/opt/compose/stirling-pdf/configs`.

For information about secret handling, see [Secrets Management](secrets-management.md).
