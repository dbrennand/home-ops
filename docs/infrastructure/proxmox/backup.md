# :simple-proxmox: Proxmox Backup Server (PBS)

!!! quote "What is Proxmox Backup Server?"

    [Proxmox Backup Server](https://proxmox.com/en/proxmox-backup-server/overview) is an enterprise backup solution, for backing up and restoring VMs, containers, and physical hosts.

## Deployment

PBS is deployed as a virtual machine on the Proxmox VE cluster on Node 1 (Primary). The PBS deployment is via an [ISO](https://proxmox.com/en/downloads/proxmox-backup-server) image.

1. Download the ISO to the Node 1 (Primary) storage.

2. Navigate to `proxmox01` > `Create VM`.

3. Provide the following details for `General` and click **Next**:

    | Setting       | Value       |
    | ------------- | ----------- |
    | Name          | `backup01`  |
    | Node          | `proxmox01` |
    | Start at boot | ✅           |

4. Under `OS`, select the storage where the ISO was downloaded to and choose the Proxmox Backup Server ISO image. Click **Next**.

5. Provide the following details for `Disks` and click **Next**:

    | Setting    | Value                  |
    | ---------- | ---------------------- |
    | Bus/Device | `VirtIO Block`         |
    | Storage    | `lv-ssd-crucial`       |
    | Size       | `32GB`                 |
    | Format     | `Raw disk image (raw)` |
    | Discard    | ✅                      |

6. Provide the following details for `CPU` and click **Next**:

    | Setting | Value  |
    | ------- | ------ |
    | Cores   | `4`    |
    | Type    | `host` |

7. Provide the following details for `Memory` and click **Next**:

    | Setting           | Value  |
    | ----------------- | ------ |
    | Memory (MiB)      | `5120` |
    | Ballooning Device | ❌      |

8. Leave `Network` as default, click **Next** and confirm deployment.

9. Start the `backup01` VM and open the console to begin the installation.

10. Follow the on-screen instructions to install PBS, when prompted enter the following details:

      | Setting         | Value                   |
      | --------------- | ----------------------- |
      | FQDN            | `backup01.net.dbren.uk` |
      | Email           | Enter email             |
      | Password        | Enter password          |
      | Default Gateway | `192.168.0.1`           |
      | IP Address      | `192.168.0.11/24`       |

11. Once installation has completed, login to the web interface listening on port `8007` using the FQDN and credentials entered during installation.

## Post Installation

Below are the post installation steps for configuring the PBS.

Copy SSH public key to the PBS's `authorized_keys` file:

```bash
ssh-copy-id root@backup01.net.dbren.uk
```

### Datastore Creation

The PBS requires a datastore to store backups. In my setup, the datastore resides on a CIFS share which is mounted on the PBS at `/mnt/storagebox`. Follow the steps below to mount the CIFS share and create the datastore:

1. Use the [`proxmox-storage-playbook.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-backup-cifs.yml) to mount the CIFS share on the PBS.

2. SSH to the PBS and create the datastore:

    ```bash
    proxmox-backup-manager datastore create backup01 /mnt/storagebox --keep-last 4 --keep-daily 5 --keep-weekly 2 --keep-monthly 1
    ```

### Verify Job Creation

The verify job is used to verify the integrity of the backups. SSH to the PBS and use the following command to create the verify job:

```bash
proxmox-backup-manager verify-job create verify01 --store backup01 --schedule daily
```

### HTTPS - Web Interface with Let's Encrypt

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
