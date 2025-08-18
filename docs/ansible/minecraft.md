# :material-minecraft: Minecraft

!!! note

    This page has been archived and kept for reference.

The Minecraft [playbook](https://github.com/dbrennand/home-ops/blob/main/ansible/playbooks/playbook-minecraft.yml) is used to deploy Minecraft servers on Ubuntu Server 22.04 LTS in my Homelab.

## :simple-ansible: Ansible Playbook

The playbook configures two Minecraft servers, `minecraft01` and `minecraft02`; each with different configuration. Both Minecraft servers are deployed using the [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server) container image.

## Vanilla Server

The `minecraft01` server is deployed with [Paper MC](https://papermc.io/). Server specific settings are located in [`ansible/vars/paper_minecraft.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/vars/paper-minecraft.yml).

## Modded Server

The `minecraft02` server is deployed with the [All the Mods 9 (ATM9)](https://www.curseforge.com/minecraft/modpacks/all-the-mods-9) modpack. Server specific settings are located in [`ansible/vars/modded_minecraft.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/vars/modded-minecraft.yml).

### Staging the Modpack Server ZIP File

To run ATM9 on the `minecraft02` server, the modpack server ZIP file must be staged on the server prior to running the Ansible playbook.

1. Download the modpack server ZIP file from [CurseForge](https://www.curseforge.com/minecraft/modpacks/all-the-mods-9/files/5125809/additional-files).

2. SCP the modpack server ZIP file to `minecraft02`:

    ```bash
    ssh daniel@minecraft02.net.dbren.uk mkdir -pv ~/modpacks
    scp /path/to/Server-Files-0.2.41.zip minecraft02.net.dbren.uk:~/modpacks/
    ```

3. Update the [`ansible/vars/modded_minecraft.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/vars/modded-minecraft.yml) file with the correct modpack server ZIP file name:

    ```yaml
    minecraft_options:
      CF_SERVER_MOD: /modpacks/Server-Files-0.2.41.zip
    ```

## Server Files & World Backup

The Ansible playbook is configured to deploy the [itzg/mc-backup](https://github.com/itzg/docker-mc-backup) container image which will backup the Minecraft server files and world to a Backblaze B2 S3 bucket. This occurs every 24 hours.

See [dbrennand | home-ops Backblaze](../infrastructure/backblaze.md) for more information on how to configure the Backblaze B2 S3 bucket.

### itzg/mc-backup - Removing Stale Locks

You may come across the following error in the logs. This occurs when the server is shut down unexpectedly during a backup and the restic lock file is not removed:

```bash
docker logs minecraft-backup
# ...
ERROR the `unlock` command can be used to remove stale locks
```

Remove the lock file by running `restic unlock`:

```bash
docker restart minecraft-backup; docker exec -it minecraft-backup restic -r b2:<bucket name> unlock
```

## :simple-tailscale: Tailscale

Tailscale is used on the server to allow friends to connect to the server remotely.

## :simple-opentofu: OpenTofu

Both servers are deployed using [OpenTofu](../infrastructure/opentofu.md).

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
