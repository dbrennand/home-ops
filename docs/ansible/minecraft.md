# Minecraft

The Ansible [minecraft-playbook.yml](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/minecraft-playbook.yml) is used to deploy a Minecraft server on Ubuntu Server 22.04 LTS in my Homelab.

## Overview

The Minecraft server is deployed with [Paper MC](https://papermc.io/) in a Docker container using the [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server) container image. The playbook deploys [Tailscale](https://tailscale.com/) to allow remote access and to allow friends to connect to the server. Furthermore, the playbook can be configured to deploy the [itzg/mc-backup](https://github.com/itzg/docker-mc-backup) container image which will backup the Minecraft server world to an S3 bucket.

## Prerequisites

### Ubuntu Server 22.04 LTS

Deploy an Ubuntu Server 22.04 LTS instance on Proxmox VE using the [VM](https://github.com/dbrennand/home-ops/tree/dev/terraform/vm) Terraform resources.

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

## Playbook Variables

The variables for this playbook are located in [ansible/vars/minecraft.yml](https://github.com/dbrennand/home-ops/blob/dev/ansible/vars/minecraft.yml).

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible
    ```

2. Create the Python virtual environment and install Ansible dependencies:

    ```bash
    task venv
    task ansible:requirements
    ```

3. Verify Ansible can connect to the server:

    ```bash
    task ansible:adhoc -- minecraft.net.dbren.uk -m ping
    ```

4. Run the playbook:

    ```bash
    task ansible:play -- playbooks/minecraft-playbook.yml
    # The following tags are supported: minecraft, backup
    # Example using tags:
    task ansible:play -- playbooks/minecraft-playbook.yml --tags minecraft
    ```
