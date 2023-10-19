# Ansible - NUC

This directory contains the Ansible [playbook](playbook.yml) that I use to configure my NUC in my Homelab.

## Overview

The NUC in my Homelab is used as a media server and is running [OpenMediaVault 6 (OMV)](https://www.openmediavault.org/).

- Model: NUC6CAYB
- CPU: Intel Celeron J3455 @ 1.50Ghz
- Memory: 8GB
- Storage
    - OS: 240GB SSD
    - Media: Samsung 860 QVO 1 TB SSD

The Ansible [playbook.yml](playbook.yml) deploys the following containerised applications:

- [Caddy](https://caddyserver.com/)
- [haugene/transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn)
- [Prowlarr](https://wiki.servarr.com/prowlarr)
- [Sonarr](https://sonarr.tv/)
- [Radarr](https://radarr.video/)
- [Jellyfin](https://jellyfin.org/)

[Docker](https://docs.docker.com/engine/) is the container engine of choice. Furthermore, [Tailscale](https://tailscale.com/) is installed for access to Jellyfin remotely and [Autorestic](https://autorestic.vercel.app/) is installed and configured to recursively backup the OMV shared folder to a Backblaze S3 bucket.

## Prerequisites

### OMV 6

> The assumption is made that you've already [flashed](https://docs.openmediavault.org/en/5.x/installation/via_iso.html) the [OMV ISO](https://www.openmediavault.org/?page_id=77) to a USB and performed the basic installation.

See [here](https://homeops.danielbrennand.com/infrastructure/NUC/openmediavault/) for instructions on how to configure OMV 6 on the NUC.

### DNS Records

[Pi-hole](../raspberrypi3/README.md) is used as the local DNS server with the following DNS records configured:

| Record Type | FQDN                          | Value                |
| ----------- | ----------------------------- | -------------------- |
| A           | `nuc.net.domain.tld`          | `192.168.0.3`        |
| CNAME       | `jellyfin.net.domain.tld`     | `nuc.net.domain.tld` |
| CNAME       | `prowlarr.net.domain.tld`     | `nuc.net.domain.tld` |
| CNAME       | `radarr.net.domain.tld`       | `nuc.net.domain.tld` |
| CNAME       | `sonarr.net.domain.tld`       | `nuc.net.domain.tld` |
| CNAME       | `transmission.net.domain.tld` | `nuc.net.domain.tld` |

### Tailscale

- You **must** have [MagicDNS](https://tailscale.com/kb/1081/magicdns/) and [HTTPS Certificate](https://tailscale.com/kb/1153/enabling-https/) features enabled for your Tailnet.

- Generate a Tailscale [auth key](https://login.tailscale.com/admin/settings/keys) to register the NUC with your Tailnet.

### Backblaze B2 Bucket

- Create a [Backblaze B2 bucket](https://help.backblaze.com/hc/en-us/articles/1260803542610-Creating-a-B2-Bucket-using-the-Web-UI) with the following settings:

  | Setting             | Value                                  |
  | ------------------- | -------------------------------------- |
  | Files in bucket are | Private                                |
  | Default Encryption  | Disable                                |
  | Object Lock         | Disable                                |
  | Lifecycle Settings  | Keep only the last version of the file |

- Generate a Backblaze B2 [application key](https://secure.backblaze.com/app_keys.htm) for the bucket with the following permissions: `deleteFiles`, `listBuckets`, `listFiles`, `readBucketEncryption`, `readBuckets`, `readFiles`, `shareFiles`, `writeBucketEncryption`, `writeFiles`.

### Cloudflare ☁️

- Domain registered with [Cloudflare](https://dash.cloudflare.com/).

- Generate a [API token](https://github.com/dbrennand/ansible-role-caddy-docker/blob/main/README.md#example---cloudflare-dns-01-challenge).

## Dependencies

- Python `>=3.11`

- Ansible `>=2.14`

## Playbook Requirements and Variables

The required Ansible collections and roles for this playbook are located in [requirements.yml](requirements.yml).

The variables for this playbook are located in [vars/main.yml](vars/main.yml).

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible/nuc
    ```

2. Edit the inventory file [inventory.yml](inventory.yml) with the NUC FQDN/IP address and `ansible_user`.

3. Create the Python virtual environment and install Ansible dependencies:

    ```bash
    task venv
    task ansible:requirements
    ```

4. Verify Ansible can connect to the NUC:

    ```bash
    task ansible:adhoc -- -m ping
    ```

5. Edit the playbook variables file [main.yml](vars/main.yml).

6. Encrypt the playbook variables file:

    ```bash
    task ansible:encrypt
    ```

7. Run the playbook:

    ```bash
    task ansible:play -- --ask-vault-pass
    # The following tags are supported: transmission, tailscale
    # Example using tags:
    task ansible:play -- --ask-vault-pass --tags tailscale
    ```

## Application Configuration

See [NUC Ansible Playbook - Application Configuration](https://homeops.danielbrennand.com/infrastructure/NUC/post-config/) for instructions on configuring Sonarr, Radarr, Prowlarr and Jellyfin.
