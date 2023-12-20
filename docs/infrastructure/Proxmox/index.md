# Proxmox

!!! quote "What is Proxmox?"

    [Proxmox Virtual Environment](https://www.proxmox.com/en/) is a complete open-source platform for enterprise virtualization. With the built-in web interface you can easily manage VMs and containers, software-defined storage and networking, high-availability clustering, and multiple out-of-the-box tools using a single solution.

## Proxmox VE Specs

[Minisforum Venus Series UN1265](https://store.minisforum.uk/collections/intel/products/un1265)

| Component          | Details                                                                           |
| :----------------- | :-------------------------------------------------------------------------------- |
| CPU                | Intel® Core™ i7-12650H Processor, 10 Cores/16 Threads (24M Cache, up to 4.70 GHz) |
| Memory             | 64GB DDR4 3200MHz SODIMM (2x32GB)                                                 |
| Storage (Internal) | Samsung NVMe 970 EVO Plus 1TB                                                     |
| Storage (External) | Crucial SSD MX500 2TB                                                             |
| Storage (External) | Samsung SSD 870 QVO 1TB                                                           |
| Storage (External) | 64GB USB                                                                          |

## Installation

1. Power on the server and enter the BIOS.

2. Go to `Advanced` > `System Devices Configuration` and set `VT-d` and `SR-IOV` to `Enabled`.

3. Download the [Proxmox VE ISO](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso) and flash it to a USB drive using a tool such as [Etcher](https://etcher.balena.io/).

4. Insert the USB drive into the server and boot to the USB by pressing the `DELETE` key during boot.

5. Follow the on-screen instructions to install Proxmox VE, when prompted enter the following details:

      | Setting         | Value                    |
      | --------------- | ------------------------ |
      | Install Disk    | `/dev/nvme0n1`           |
      | FQDN            | `proxmox01.net.dbren.uk` |
      | Email           | Enter email              |
      | Password        | Enter password           |
      | Default Gateway | `192.168.0.1`            |
      | IP Address      | `192.168.0.4/24`         |

6. Once installation has completed, login to the web interface listening on port `8006` using the FQDN and credentials entered during installation.

## Post Installation

Below are the post installation steps for configuring the Proxmox VE server.

Copy SSH public key to the Proxmox VE server's `authorized_keys` file:

```bash
ssh-copy-id -i root@proxmox01.net.dbren.uk
```

### Storage

!!! info

    I chose not to automate this process because it only has to be done one time and takes only a few minutes to complete.

1. Extend the Proxmox `data` logical volume to use the remaining space in the volume group:

    ```bash
    lvextend -l +100%FREE /dev/pve/data
    ```

2. Login to the Proxmox web interface and navigate to `Datacenter` > `proxmox01` > `Disks`:

    - Click `/dev/sda` and select `Initialize Disk with GPT`
    - Click `/dev/sdb` and select `Initialize Disk with GPT`
    - Click `/dev/sdc` and select `Initialize Disk with GPT`

3. Navigate to `Disks` > `LVM-Thin` > `Create: Thinpool`, enter the following details and click **Create**:

      | Setting | Value       |
      | ------- | ----------- |
      | Disk    | `/dev/sda`  |
      | Name    | ssd-crucial |

      | Setting | Value       |
      | ------- | ----------- |
      | Disk    | `/dev/sdb`  |
      | Name    | ssd-samsung |

4. Navigate to `Disks` > `Directory` > `Create: Directory`, enter the following details and click **Create**:

      | Setting    | Value      |
      | ---------- | ---------- |
      | Disk       | `/dev/sdc` |
      | Filesystem | `xfs`      |
      | Name       | ISOs       |

### Scripts

!!! warning

    Proceed with caution, before running any of the scripts below, make sure to review the code to ensure it is safe to run.

1. Run the [Proxmox VE post install](https://github.com/tteck/Proxmox) script:

    ```bash
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pve-install.sh)"
    ```

2. Run the [Proxmox Dark Theme](https://github.com/Weilbyte/PVEDiscordDark) script:

    ```bash
    bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install
    ```
