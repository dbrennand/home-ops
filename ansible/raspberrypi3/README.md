# Ansible - Raspberry Pi 3

This directory contains the Ansible [playbook](playbook.yml) that I use to configure my Raspberry Pi 3 in my Homelab.

## Overview

The Raspberry Pi 3 in my Homelab acts as a DNS server by running [Pi-hole](https://pi-hole.net/) in a container. Furthermore, I configure [Tailscale](https://tailscale.com/) to be able to get ad-blocking whilst on the go.

## Prerequisites

### Raspberry Pi OS

1. Flash Raspberry Pi OS Lite (64-bit) to a micro SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

2. Click the **cog icon** on the bottom right to open the *Advanced options* menu and configure the following options:

    - Set hostname to `pihole`.
    - Enable SSH and allow public key authentication only. Enter your public key in the `authorized_keys` field.
    - Set a username and password.
    - Set locale settings as appropriate.
    - Disable telemetry.

3. Once flashed, insert the micro SD card into the Raspberry Pi and boot it.

4. SSH to the Raspberry Pi:

    > **Note**
    > If you experience issues with hostname resolution on MacOS, try restarting the [mDNSResponder service](https://stackoverflow.com/questions/20252294/ssh-could-not-resolve-hostname-hostname-nodename-nor-servname-provided-or-n): `sudo killall -HUP mDNSResponder`.

    ```bash
    ssh <user>@pihole
    ```

5. Run the following commands on the Raspberry Pi to set a static IP address, update the system and expand the filesystem:

    ```bash
    # Become root
    sudo -i
    raspi-config
    # Select "Advanced Options" > "Network Config" > 2 NetworkManager
    # Select "Advanced Options" > "Expand Filesystem"

    # Set static IP address
    nmcli connection modify eth0 ipv4.method manual ipv4.addresses 192.168.0.2/24 ipv4.gateway 192.168.0.1 ipv4.dns 1.1.1.1,1.0.0.1 connection.autoconnect yes

    # Enable connection to apply changes
    nmcli connection up eth0

    # Update system
    apt-get update && apt-get upgrade -y
    reboot
    ```

### Tailscale

- Generate a Tailscale [auth key](https://login.tailscale.com/admin/settings/keys) to register the Raspberry Pi 3 with your Tailnet.

## Dependencies

- Python `>=3.11`

- Ansible `>=2.14`

## Playbook Requirements & Variables

The required Ansible collections and roles for this playbook are located in [requirements.yml](requirements.yml).

The variables for this playbook are located in [vars/main.yml](vars/main.yml).

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/dbrennand/home-ops.git && cd home-ops/ansible/raspberrypi3
    ```

2. Edit the [inventory.yml](inventory.yml) file with the Raspberry Pi 3 IP address and `ansible_user`.

3. Create the Python virtual environment and install Ansible dependencies:

    ```bash
    task venv
    task ansible:requirements
    ```

4. Verify Ansible can connect to the Raspberry Pi 3:

    ```bash
    task ansible:adhoc -- -m ping
    ```

5. Edit the playbook variables file [main.yml](vars/main.yml) as appropriate for your setup.

6. Encrypt the playbook variables file:

    ```bash
    task ansible:encrypt
    ```

7. Run the playbook:

    ```bash
    task ansible:play -- --ask-vault-pass
    # The following tags are supported: tailscale
    # Example using tags:
    task ansible:play -- --ask-vault-pass --tags tailscale
    ```

## Post Configuration - Setting the Pi-hole as the Tailnet Global Nameserver

1. Login to the Tailscale [admin portal](https://login.tailscale.com/admin/machines).

2. Copy the Tailnet IP of the Raspberry Pi 3. The hostname should be `pihole`.

3. Select the `pihole` machine in the portal and under machine settings, select **Disable key expiry**.

4. Go to your Tailnet's [DNS settings](https://login.tailscale.com/admin/dns) and under *Nameservers*, choose **Add nameserver** > **Custom...**.

5. Enter the Tailnet IP of the Raspberry Pi 3 as the nameserver and click **Save**.

6. Check **Override local DNS**.

Now when you connect to your Tailnet from your mobile device, you'll get Pi-hole ad-blocking! 🚀

Enjoy! ✨🚀
