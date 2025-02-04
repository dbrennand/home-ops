# :simple-proxmox: Proxmox

The following page contains information on the Proxmox related Ansible playbooks used in my Homelab.

## :simple-ansible: Ansible Playbooks

The following playbooks are used to configure Proxmox VE in my Homelab:

| Playbook Name                                                                                                                   | Description                                    |
| ------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| [`proxmox-storage-playbook.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-storage-playbook.yml) | Provision Proxmox LVM Storage.                 |
| [`proxmox-external-vote.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-external-vote.yml)       | Proxmox Nodes - Cluster External Vote Support. |

See [dbrennand | home-ops - Proxmox](https://homeops.danielbrennand.com/infrastructure/proxmox/ve) for further details.

### Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible
    ```

2. Create the Python virtual environment:

    ```bash
    task venv
    ```

3. Verify Ansible can connect to the Proxmox VE servers:

    ```bash
    task ansible:adhoc -- proxmox -m ping
    ```

4. Run the playbook(s):

    ```bash
    task ansible:play -- playbooks/proxmox-storage-playbook.yml
    task ansible:play -- playbooks/proxmox-external-vote.yml
    ```

## Proxmox Backup Server

The following playbooks are used to configure Proxmox Backup Server in my Homelab:

| Playbook Name                                                                                                         | Description       |
| --------------------------------------------------------------------------------------------------------------------- | ----------------- |
| [`proxmox-backup-cifs.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-backup-cifs.yml) | Mount CIFS Share. |

See [dbrennand | home-ops - Proxmox Backup Server](https://homeops.danielbrennand.com/infrastructure/proxmox/backup) for further details.

### Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible
    ```

2. Create the Python virtual environment:

    ```bash
    task venv
    task ansible:requirements
    ```

3. Verify Ansible can connect to the Proxmox VE servers:

    ```bash
    task ansible:adhoc -- backup01.net.dbren.uk -m ping
    ```

4. Run the playbook:

    ```bash
    task ansible:play -- playbooks/proxmox-backup-cifs.yml
    ```
