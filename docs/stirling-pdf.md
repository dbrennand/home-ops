# Stirling PDF

Stirling PDF is hosted at
[`stirling.apps.dbren.uk`](https://stirling.apps.dbren.uk). Home clients resolve
this public hostname through Pangolin. The Pangolin site connector on `pi01`
proxies requests to Stirling PDF on `127.0.0.1:8080`; the container port is
bound to host loopback and is not exposed directly to the home network.
The public DNS record for `stirling.apps.dbren.uk` must resolve to the Pangolin
server so clients reach the resource through Pangolin.

The [`pangolin_site_playbook.yml`](../pangolin_site_playbook.yml) deploys the
site connector and public resource blueprint. The
[`stirling_pdf_playbook.yml`](../stirling_pdf_playbook.yml) deploys Stirling PDF.

Pangolin requires SSO for the public resource and grants access to users in the
`Member` role. Stirling's own login remains disabled; access is controlled
through Pangolin's configured identity provider.

## Persistent data

Stirling's settings and application data are stored at `/opt/compose/stirling-pdf/configs`.

For information about secret handling, see [Secrets Management](secrets-management.md).
