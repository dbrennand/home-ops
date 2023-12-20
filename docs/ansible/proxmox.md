# Ansible - Proxmox VE

The following playbooks are used to configure Proxmox VE in my Homelab:

- [proxmox-create-vm-template.yml](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-create-vm-template.yml): Create VM templates.
- [proxmox-download-iso-playbook.yml](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/proxmox-download-iso-playbook.yml): Download ISOs to Proxmox.

See [dbrennand | home-ops - Proxmox](https://homeops.danielbrennand.com/infrastructure/Proxmox/) for further details.

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible
    ```

2. Create the Python virtual environment:

    ```bash
    task venv
    ```

3. Verify Ansible can connect to the Proxmox VE server:

    ```bash
    task ansible:adhoc -- -m ping
    ```

4. Run the playbook(s):

    ```bash
    task ansible:play -- playbooks/proxmox-download-iso-playbook.yml
    task ansible:play -- playbooks/proxmox-create-vm-template.yml
    ```
