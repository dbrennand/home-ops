# :simple-pihole: Pi-hole

The Pi-hole [playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/pihole-playbook.yml) is used to deploy and configure Pi-hole on my Raspberry Pi 3 in my Homelab.

## Overview

The Raspberry Pi 3 in my Homelab acts as a DNS server by running [Pi-hole](https://pi-hole.net/) in a container.

## Prerequisites

### Raspberry Pi OS

1. Flash Raspberry Pi OS Lite (64-bit) to a micro SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

2. Click the **cog icon** on the bottom right to open the *Advanced options* menu and configure the following options:

    - Set hostname to `pihole01`.
    - Enable SSH and allow public key authentication only. Enter your public key in the `authorized_keys` field.
    - Set a username and password.
    - Set locale settings as appropriate.
    - Disable telemetry.

3. Once flashed, insert the micro SD card into the Raspberry Pi and boot it.

4. SSH to the Raspberry Pi:

    > **Note**
    > If you experience issues with hostname resolution on MacOS, try restarting the [mDNSResponder service](https://stackoverflow.com/questions/20252294/ssh-could-not-resolve-hostname-hostname-nodename-nor-servname-provided-or-n): `sudo killall -HUP mDNSResponder`.

    ```bash
    ssh <user>@pihole01
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

### Cloudflare API Token (DNS-01 Challenge)

Generate a Cloudflare API Token using the following [instructions](https://github.com/dbrennand/ansible-role-caddy-docker#example---cloudflare-dns-01-challenge).

## :simple-ansible: Playbook Requirements & Variables

The variables for this playbook are located in [`ansible/vars/pihole.yml`](https://github.com/dbrennand/home-ops/blob/dev/ansible/vars/pihole.yml).

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
    task ansible:adhoc -- pihole01.net.dbren.uk -m ping
    ```

4. Run the playbook:

    ```bash
    task ansible:play -- playbooks/pihole-playbook.yml
    ```

## Post Configuration - Setting the Pi-hole as the Tailnet Global Nameserver

1. Login to the Tailscale [admin portal](https://login.tailscale.com/admin/machines).

2. Copy the Tailnet IP of the Raspberry Pi 3. The hostname should be `pihole01`.

3. Select the `pihole01` machine in the portal and under machine settings, select **Disable key expiry**.

4. Go to your Tailnet's [DNS settings](https://login.tailscale.com/admin/dns) and under *Nameservers*, choose **Add nameserver** > **Custom...**.

5. Enter the Tailnet IP of the Raspberry Pi 3 as the nameserver and click **Save**.

6. Check **Override local DNS**.

Now when you connect to your Tailnet from your mobile device, you'll get Pi-hole ad-blocking! 🚀

Enjoy! ✨🚀
