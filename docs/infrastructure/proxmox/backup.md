# :simple-proxmox: Proxmox Backup Server (PBS)

!!! quote "What is Proxmox Backup Server?"

    [Proxmox Backup Server](https://proxmox.com/en/proxmox-backup-server/overview) is an enterprise backup solution, for backing up and restoring VMs, containers, and physical hosts.

## Deployment

PBS is deployed as a virtual machine on the Proxmox VE Node 1. The PBS deployment is via an [ISO](https://proxmox.com/en/downloads/proxmox-backup-server) image.

1. Download the ISO to the Node 1 storage.

2. Navigate to `proxmox01` > `Create VM`.

3. Provide the following details for `General` and click **Next**:

    | Setting       | Value       |
    | ------------- | ----------- |
    | Name          | `backup01`  |
    | Node          | `proxmox01` |
    | Start at boot | ✅           |

4. Under `OS`, select the storage where the ISO was downloaded to and choose the Proxmox Backup Server ISO image. Click **Next**.

5. Under `System`, select the `VirtIO SCSI Single` controller and click **Next**.

6. Provide the following details for `Disks` and click **Next**:

    | Setting       | Value                  |
    | ------------- | ---------------------- |
    | Bus/Device    | `SCSI`                 |
    | Storage       | `lv-ssd-crucial`       |
    | Size          | `32GiB`                |
    | Format        | `Raw disk image (raw)` |
    | Discard       | ✅                      |
    | SSD Emulation | ✅                      |

    | Setting       | Value                  |
    | ------------- | ---------------------- |
    | Bus/Device    | `SCSI`                 |
    | Storage       | `lv-ssd-crucial`       |
    | Size          | `150GiB`               |
    | Format        | `Raw disk image (raw)` |
    | Discard       | ✅                      |
    | SSD Emulation | ✅                      |

7. Provide the following details for `CPU` and click **Next**:

    | Setting | Value  |
    | ------- | ------ |
    | Cores   | `4`    |
    | Type    | `host` |

8. Provide the following details for `Memory` and click **Next**:

    | Setting           | Value  |
    | ----------------- | ------ |
    | Memory (MiB)      | `5120` |
    | Ballooning Device | ✅      |
    | Minimum Memory    | `1024` |

9. Leave `Network` as default, click **Next** and confirm deployment.

10. Start the `backup01` VM and open the console to begin the installation.

11. Follow the on-screen instructions to install PBS, when prompted enter the following details:

      | Setting         | Value                   |
      | --------------- | ----------------------- |
      | FQDN            | `backup01.net.dbren.uk` |
      | Email           | Enter email             |
      | Password        | Enter password          |
      | Default Gateway | `192.168.0.1`           |
      | IP Address      | `192.168.0.6/24`        |

12. Once installation has completed, login to the web interface listening on port `8007` using the FQDN and credentials entered during installation.

## Post Installation

Below are the post installation steps for configuring the PBS.

Copy SSH public key to the PBS's `authorized_keys` file:

```bash
ssh-copy-id root@backup01.net.dbren.uk
```

### Datastore Creation

The PBS requires a datastore to store backups. In my setup, I have two datastores, one which is a [Hetzner Storagebox](https://docs.hetzner.com/robot/storage-box/general) mounted via CIFS on the PBS at `/mnt/storagebox`, and the other which is a local disk.

!!! info "Documentation"

    [Proxmox Backup Server - Backup Storage](https://pbs.proxmox.com/docs/storage.html)

#### Hetzner Storagebox Datastore

1. Use the [`playbook-proxmox-backup-cifs.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/playbooks/playbook-proxmox-backup-cifs.yml) to mount the CIFS share on the PBS.

2. SSH to the PBS and create the datastore:

    ```bash
    proxmox-backup-manager datastore create Remote /mnt/storagebox --gc-schedule "sun 04:00"
    ```

#### Local Datastore

1. SSH to the PBS and initialise the disk with a GPT:

    ```bash
    proxmox-backup-manager disk initialize sdb
    ```

2. Create the datastore:

    ```bash
    proxmox-backup-manager disk fs create Local --disk sdb --filesystem ext4 --add-datastore true
    ```

3. Configure the datastore:

    ```bash
    proxmox-backup-manager datastore update Local --gc-schedule "sun 04:00"
    ```

### Verify Job Creation

The verify job is used to verify the integrity of the backups. SSH to the PBS and use the following command to create the verify job:

```bash
proxmox-backup-manager verify-job create verify-Local --store Local --schedule "03:00" --ignore-verified=true --outdated-after=30
```

### Sync Job Creation

!!!info "Local & Offsite Copy"

    This makes sure that I have a local copy of backups and an offsite copy on the Hetzner Storagebox.

Configure the backups to sync from the `Local` datastore to `Remote` datastore:

```bash
proxmox-backup-manager sync-job create sync-pull-Local-Remote --owner 'root@pam' --store Remote --remote-store Local --schedule "02:00" --remove-vanished=true
```

### :simple-letsencrypt: HTTPS - Web Interface with Let's Encrypt

!!! info "Cloudflare API Token & Zone ID"

    See the following [instructions](https://github.com/dbrennand/ansible-role-caddy-docker#example---cloudflare-dns-01-challenge) for generating a Cloudflare API Token.

    Furthermore, you will need to obtain your domain's zone ID. This can be found in the Cloudflare dashboard page for the domain, on the right side under *API* > *Zone ID*.

1. Login to the PBS GUI and go to `Configuration` > `Certificates` > `ACME Accounts` > *Accounts* and click **Add**:

    | Setting        | Value              |
    | -------------- | ------------------ |
    | Account Name   | `default`          |
    | Email          | `<Email>`          |
    | ACME Directory | `Let's Encrypt V2` |
    | Accept TOS     | `True`             |

2. Click **Register**.

3. Under *Challenge Plugins*, click **Add** and enter the following details:

    | Setting    | Value                    |
    | ---------- | ------------------------ |
    | Plugin ID  | `cloudflare`             |
    | DNS API    | `Cloudflare Managed API` |
    | CF_Token   | `<Cloudflare API Token>` |
    | CF_Zone_ID | `<Cloudflare Zone ID>`   |

4. Click **Add**.

5. Navigate to `Certificates` and under *ACME* click **Add**:

    | Setting        | Value                   |
    | -------------- | ----------------------- |
    | Challenge Type | `DNS`                   |
    | Plugin         | `cloudflare`            |
    | Domain         | `backup01.net.dbren.uk` |

6. Click **Create**.

7. Under *ACME* > for `Using Account` click **Edit** and select the `default` account and click **Apply**.

8. Click **Order Certificates Now**.

Once completed, the PBS web interface will reload and show the new certificate.

### :fontawesome-solid-terminal: Scripts

!!! warning

    Proceed with caution, before running any of the scripts below, make sure to review the code to ensure it is safe to run.

1. Run the [PBS post install](https://github.com/tteck/Proxmox) script on PBS:

    !!! quote

        The script will give options to Disable the Enterprise Repo, Add/Correct PBS Sources, Enable the No-Subscription Repo, Add Test Repo, Disable Subscription Nag, Update Proxmox Backup Server and Reboot PBS.

    ```bash
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pbs-install.sh)"
    ```

## Backup Operations

Backup operations are performed using the [`proxmox-backup-client`](https://pbs.proxmox.com/docs/backup-client.html) command on the Proxmox VE nodes. Below are some common operations.

### View all snapshots for a datastore

```bash
proxmox-backup-client snapshot list --repository backup01.net.dbren.uk:backup01
```

### View snapshots for a VM

```
proxmox-backup-client snapshot list vm/102 --repository backup01.net.dbren.uk:backup01
```

### Delete a snapshot for a VM

```bash
proxmox-backup-client snapshot forget vm/102/2024-06-27T16:57:49Z --repository backup01.net.dbren.uk:backup01
```
