# Proxmox

!!! quote "What is Proxmox?"

    [Proxmox Virtual Environment](https://www.proxmox.com/en/) is a complete open-source platform for enterprise virtualization. With the built-in web interface you can easily manage VMs and containers, software-defined storage and networking, high-availability clustering, and multiple out-of-the-box tools using a single solution.

## Proxmox VE Specs

### Node 1 (Primary)

[Minisforum Venus Series UN1265](https://store.minisforum.uk/collections/intel/products/un1265)

| Component          | Details                                                                           |
| ------------------ | --------------------------------------------------------------------------------- |
| CPU                | Intel® Core™ i7-12650H Processor, 10 Cores/16 Threads (24M Cache, up to 4.70 GHz) |
| Memory             | 64GB DDR4 3200MHz SODIMM (2x32GB)                                                 |
| Storage (Internal) | Samsung NVMe 970 EVO Plus 1TB                                                     |
| Storage (External) | Crucial SSD MX500 2TB                                                             |
| Storage (External) | Samsung SSD 870 QVO 1TB                                                           |
| Storage (External) | 64GB USB                                                                          |


### Node 2 (Secondary)

[Intel NUC6CAYB](https://www.intel.com/content/dam/support/us/en/documents/boardsandkits/NUC6CAYB_TechProdSpec.pdf)

| Component          | Details                       |
| ------------------ | ----------------------------- |
| CPU                | Intel Celeron J3455 @ 1.50Ghz |
| Memory             | 8GB                           |
| Storage (Internal) | 240GB SSD                     |

## Installation

!!! note

    The following instructions are for Node 1 (Primary). Modify the *install disk*, *FQDN* and *IP Address* values for Node 2 (Secondary).

1. Power on the node and enter the BIOS.

2. Go to `Advanced` > `System Devices Configuration` and set `VT-d` and `SR-IOV` to `Enabled`.

3. Download the [Proxmox VE ISO](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso) and flash it to a USB drive using a tool such as [Etcher](https://etcher.balena.io/).

4. Insert the USB drive into the node and boot to the USB by pressing the `DELETE` key during boot.

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

Below are the post installation steps for configuring the Proxmox VE nodes.

Copy SSH public key to the Proxmox VE node's `authorized_keys` file:

```bash
ssh-copy-id root@proxmox01.net.dbren.uk
```

### Storage

1. Extend the Proxmox `data` logical volume on each node to use the remaining space in the volume group:

    ```bash
    lvextend -l +100%FREE /dev/pve/data
    ```

2. Use the [proxmox-storage-playbook.yml](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-storage-playbook.yml) to configure the Proxmox storage on Node 1 (Primary).

### Establish Proxmox Cluster

!!! note

    I chose to not automate the following steps because it only needs to be done once.

1. Navigate to the Proxmox GUI on Node 1 (Primary) and go to `Datacenter` > `Cluster` > `Create Cluster`:

    | Setting | Value      |
    | ------- | ---------- |
    | Name    | `home-ops` |

2. Once the cluster has been created, click **Join Information** and copy the alphanumeric string to the clipboard.

3. Navigate to the Proxmox GUI on Node 2 (Secondary) and go to `Datacenter` > `Cluster` > `Join Cluster` and paste the alphanumeric string into the text box.

4. Enter Node 1's root password for the *peer's root password* field and click **Join 'home-ops'**.

5. Wait for the cluster to establish. You will know when this has completed as on each node's GUIs you should now see the other node listed under `Datacenter`.

#### Create External Vote Server

Due to the Proxmox cluster only consisting of two nodes, there is no way to establish quorum.

!!! quote "What's Quroum?"

    A [quorum](https://pve.proxmox.com/wiki/Cluster_Manager#_quorum) is the minimum number of votes that a distributed transaction has to obtain in order to be allowed to perform an operation in a distributed system.

Without quorum, if one node goes down, the other node will not be able to determine if it is the only node left in the cluster or if the other node is still running. This is often referred to as a *split-brain* scenario. Luckily, Proxmox's Corosync supports an external vote server (known as a Corosync Quorum Device (QDevice)) to act as a tie-breaker. This lightweight daemon can be run on a device such as a Raspberry Pi.

1. Execute the [proxmox-external-vote.yml](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-external-vote.yml) playbook to configure the Proxmox nodes and external vote server on the Raspberry Pi:

    ```bash
    task ansible:play -- proxmox-external-vote.yml
    ```

2. On Proxmox Node 1 (Primary), execute the following command to add the QDevice to the cluster:

    ```bash
    pvecm qdevice setup 192.168.0.3
    ```

3. Once added, verify the QDevice is online:

    ```bash
    pvecm status
    ```

If the QDevice is successfully added, you should see the following:

```
Membership information
----------------------
    Nodeid      Votes    Qdevice Name
0x00000001          1    A,V,NMW 192.168.0.4 (local)
0x00000002          1    A,V,NMW 192.168.0.3
0x00000000          1            Qdevice
```

### Scripts

!!! warning

    Proceed with caution, before running any of the scripts below, make sure to review the code to ensure it is safe to run.

1. Run the [Proxmox VE post install](https://github.com/tteck/Proxmox) script on both PVE nodes:

    !!! quote

        This script provides options for managing Proxmox VE repositories, including disabling the Enterprise Repo, adding or correcting PVE sources, enabling the No-Subscription Repo, adding the test Repo, disabling the subscription nag, updating Proxmox VE, and rebooting the system.

    ```bash
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pve-install.sh)"
    ```

2. Run the [Proxmox Dark Theme](https://github.com/Weilbyte/PVEDiscordDark) script:

    !!! quote

        A dark theme for the Proxmox VE Web UI is a custom theme created by [Weilbyte](https://github.com/Weilbyte/PVEDiscordDark) that changes the look and feel of the Proxmox web-based interface to a dark color scheme. This theme can improve the visual experience and make the interface easier on the eyes, especially when used in low-light environments.

    ```bash
    bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install
    ```
