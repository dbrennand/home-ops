# Ansible - Minecraft

This directory contains the Ansible [playbook](playbook.yml) that I use to deploy a Minecraft server on Ubuntu Server 22.04 LTS.

## Overview

The Minecraft server is deployed with [Paper MC](https://papermc.io/) in a Docker container using the [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server) container image. The playbook deploys [Tailscale](https://tailscale.com/) to allow remote access and to allow friends to connect to the server. Furthermore, the playbook can be configured to deploy the [itzg/mc-backup](https://github.com/itzg/docker-mc-backup) container image which will backup the Minecraft server world to an S3 bucket.

## Prerequisites

### Ubuntu Server 22.04 LTS

Deploy an Ubuntu Server 22.04 LTS instance on Proxmox VE using the [common](../../terraform/common/) Terraform resources.

### Tailscale

Generate a Tailscale [auth key](https://login.tailscale.com/admin/settings/keys) to register the server with your Tailnet.

### Backblaze B2 Bucket

- Create a [Backblaze B2 bucket](https://help.backblaze.com/hc/en-us/articles/1260803542610-Creating-a-B2-Bucket-using-the-Web-UI) with the following settings:

  | Setting             | Value                                  |
  | ------------------- | -------------------------------------- |
  | Files in bucket are | Private                                |
  | Default Encryption  | Disable                                |
  | Object Lock         | Disable                                |
  | Lifecycle Settings  | Keep only the last version of the file |

- Generate a Backblaze B2 [application key](https://secure.backblaze.com/app_keys.htm) for the bucket with the following permissions: `deleteFiles`, `listBuckets`, `listFiles`, `readBucketEncryption`, `readBuckets`, `readFiles`, `shareFiles`, `writeBucketEncryption`, `writeFiles`.

## Dependencies

- Python `>=3.11`

- Ansible `>=2.14`

## Playbook Requirements & Variables

The required Ansible collections and roles for this playbook are located in [requirements.yml](requirements.yml).

The variables for this playbook are located in [vars/main.yml](vars/main.yml).

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible/minecraft
    ```

2. Edit the [inventory.yml](inventory.yml) file with the IP address of the server and `ansible_user`.

3. Create the Python virtual environment and install Ansible dependencies:

    ```bash
    task venv
    task ansible:requirements
    ```

4. Verify Ansible can connect to the server:

    ```bash
    task ansible:adhoc -- -m ping
    ```

5. Edit the playbook variables file [main.yml](vars/main.yml) as appropriate for your setup.

6. Encrypt the playbook variables file:

    ```bash
    task ansible:encrypt
    ```

7. Run the playbook:

    ```bash
    task ansible:play -- --ask-vault-pass
    # The following tags are supported: minecraft, tailscale, backup
    # Example using tags:
    task ansible:play -- --ask-vault-pass --tags minecraft
    ```
