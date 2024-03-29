# Minecraft

The [Minecraft playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/minecraft-playbook.yml) is used to deploy Minecraft servers on Ubuntu Server 22.04 LTS in my Homelab.

## Ansible Playbook

The playbook configures two Minecraft servers, `minecraft01` and `minecraft02`; each with different configuration. Both Minecraft servers are deployed using the [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server) container image.

## Vanilla Server

The `minecraft01` server is deployed with [Paper MC](https://papermc.io/). Server specific settings are located in [`ansible/vars/paper_minecraft.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/vars/paper_minecraft.yml).

## Modded Server

The `minecraft02` server is deployed with the [All the Mods 9 (ATM9)](https://www.curseforge.com/minecraft/modpacks/all-the-mods-9) modpack. Server specific settings are located in [`ansible/vars/modded_minecraft.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/vars/modded_minecraft.yml).

### Staging the Modpack Server ZIP File

To run ATM9 on the `minecraft02` server, the modpack server ZIP file must be staged on the server. The following steps outline how to stage the modpack server ZIP file:

1. Download the modpack server ZIP file from the [CurseForge](https://www.curseforge.com/minecraft/modpacks/all-the-mods-9/files/5125809/additional-files) website.

2. SCP the modpack server ZIP file to the `minecraft02` server:

    ```bash
    ssh daniel@minecraft02.net.dbren.uk mkdir -pv ~/modpacks
    scp /path/to/Server-Files-0.2.41.zip minecraft02.net.dbren.uk:~/modpacks/
    ```

3. Update the [`ansible/vars/modded_minecraft.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/vars/modded_minecraft.yml) file with the correct modpack server ZIP file name:

    ```yaml
    minecraft_options:
      CF_SERVER_MOD: /modpacks/Server-Files-0.2.41.zip
    ```

## Server Files & World Backup

The playbook is configured to deploy the [itzg/mc-backup](https://github.com/itzg/docker-mc-backup) container image which will backup the Minecraft server files and world to a Backblaze B2 S3 bucket.

### Backblaze B2 S3 Bucket

- Create a [Backblaze B2 bucket](https://help.backblaze.com/hc/en-us/articles/1260803542610-Creating-a-B2-Bucket-using-the-Web-UI) with the following settings:

  | Setting             | Value                                  |
  | ------------------- | -------------------------------------- |
  | Files in bucket are | Private                                |
  | Default Encryption  | Disable                                |
  | Object Lock         | Disable                                |
  | Lifecycle Settings  | Keep only the last version of the file |

- Generate a Backblaze B2 [application key](https://secure.backblaze.com/app_keys.htm) for the bucket with the following permissions: `deleteFiles`, `listBuckets`, `listFiles`, `readBucketEncryption`, `readBuckets`, `readFiles`, `shareFiles`, `writeBucketEncryption`, `writeFiles`.

## Tailscale

The [Tailscale playbook](https://homeops.danielbrennand.com/ansible/tailscale/) is used on the server to allow friends to connect to the server remotely.

## Terraform

Both servers are deployed using [Terraform](https://www.terraform.io/). See [dbrennand | home-ops - Terraform](https://homeops.danielbrennand.com/infrastructure/terraform/) for more information.

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
    task ansible:adhoc -- minecraft -m ping
    ```

4. Run the playbook:

    ```bash
    task ansible:play -- playbooks/minecraft-playbook.yml
    # The following tags are supported: minecraft, backup
    # Example using tags:
    task ansible:play -- playbooks/minecraft-playbook.yml --tags minecraft
    ```
