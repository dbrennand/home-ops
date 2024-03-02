# Tailscale

!!! quote "What is Tailscale?"

    [Tailscale](https://tailscale.com/) is a VPN service that makes the devices and applications you own accessible anywhere in the world, securely and effortlessly. It enables encrypted point-to-point connections using the open source WireGuard protocol, which means only devices on your private network can communicate with each other.

## Ansible Playbook

The [Tailscale playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/tailscale-playbook.yml) is used to deploy Tailscale onto infrastructure in my Homelab. The playbook uses the [artis3n.tailscale](https://github.com/artis3n/ansible-role-tailscale) Ansible role to manage the installation and configuration of Tailscale.

## Configuration

### Tailscale Auth Key

Generate a Tailscale [auth key](https://login.tailscale.com/admin/settings/keys) to register devices with the Tailnet and populate the `tailscale_auth_key` variable in the [`ansible/inventory/group_vars/tailscale.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/inventory/group_vars/tailscale.yml).

### Host Variables

Host variables for configuring Tailscale are located in [`ansible/inventory/inventory.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/inventory/inventory.yml#L38).

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

3. Verify Ansible can connect to the servers:

    ```bash
    task ansible:adhoc -- tailscale -m ping
    ```

4. Run the playbook:

    ```bash
    task ansible:play -- playbooks/tailscale-playbook.yml
    ```
