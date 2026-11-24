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
install Pangolin or manage its DNS records, site connectors, or resources.
Those settings must be maintained in the Pangolin deployment itself. The
intended network relationship is shown in the [architecture overview](architecture.md).

## Google sign-in

Google sign-in is configured in the Pangolin deployment and Google Cloud
Console. The built-in Google identity provider requires Pangolin Enterprise
Edition. For this deployment, set `app.identity_provider_mode: "org"` in
Pangolin's `privateConfig.yml` and apply the configuration before adding an
organization identity provider. See Pangolin's [Google identity provider
guide](https://docs.pangolin.net/manage/identity-providers/google).

### Configure Google Cloud

1. In the [Google Cloud Console](https://console.cloud.google.com/), select or
   create the project named `pangolin-dbrenuk`.
2. Open **Google Auth Platform** and complete the setup. Set the app name to
   `pangolin.apps.dbren.uk` and enter a support email.
3. Choose an audience. Use **Internal** only if every allowed account belongs
   to the same Google Workspace organization. Otherwise choose **External**.
   While an External app is in **Testing**, add each permitted Google account
   under **Test users**; Google limits a Testing app to 100 test users.
4. Under **Branding**, add `dbren.uk` as an authorized domain. Verify domain
   ownership in Google if prompted.
5. Under **Clients**, create an OAuth client with application type **Web
   application** and name it `Pangolin`. Save the generated client ID and
   client secret securely. The redirect URI will be added after Pangolin
   provides it.

### Configure Pangolin

1. In the Pangolin organization, open **Identity Providers** and select **Add
   Identity Provider**.
2. Choose **Google**, enter the Google client ID and client secret, and leave
   **Auto Provision Users** disabled.
3. Create the provider, open its **General** tab, and copy the **Redirect URL**.
4. Return to the `Pangolin` OAuth client in Google Cloud Console. Add the
   copied URL under **Authorized redirect URIs** and save the client.
5. In Pangolin, create an external user for every account allowed to sign in.
   Associate each user with the Google identity provider and assign the
   appropriate role. Use the exact identifier Pangolin expects for that
   account. If a login fails with a "No policies matched" error, Pangolin
   displays the identifier to use when creating the user.

With auto-provisioning disabled, an account must be pre-created in Pangolin to
sign in. Google may authenticate other Google accounts, but Pangolin will not
admit them to the organization unless their users are provisioned there. See
Pangolin's [identity provider instructions](https://docs.pangolin.net/manage/identity-providers/add-an-idp)
and [auto-provisioning guide](https://docs.pangolin.net/manage/identity-providers/auto-provisioning).

## Update automation

The [`pangolin_update_playbook.yml`](../pangolin_update_playbook.yml) playbook
updates the existing SQLite Enterprise Edition deployment. It checks the
latest stable releases of Pangolin, Gerbil, Traefik, and Badger, reports which
components need updating, backs up the configuration, and applies the updates.

Run it from the repository root with `uv run ansible-playbook
pangolin_update_playbook.yml`. It expects the Pangolin installation at
`/opt/pangolin` on `ubuntu01.hetzner.dbren.uk`.
