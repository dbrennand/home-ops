# Ansible - Proxmox VE

This directory contains the Ansible playbooks that I use to configure Proxmox VE in my Homelab.

See [dbrennand | home-ops - Proxmox](https://homeops.danielbrennand.com/infrastructure/proxmox/) for further details.

## Playbooks

- [download-iso-playbook.yml](download-iso-playbook.yml): Download ISO files to Proxmox.

## Dependencies

- Python `>=3.11`

- Ansible `>=2.14`

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible/proxmox
    ```

2. Edit the [inventory.yml](inventory.yml) file with the Proxmox VE server FQDN and `ansible_user`.

3. Create the Python virtual environment:

    ```bash
    task venv
    ```

4. Verify Ansible can connect to the Proxmox VE server:

    ```bash
    task ansible:adhoc -- -m ping
    ```

5. Run the playbook:

    ```bash
    PLAYBOOK="download-iso-playbook.yml" task ansible:play
    ```
