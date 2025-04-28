# :material-dns-outline: DNS

[Pi-hole](https://pi-hole.net/) is used for DNS in my Homelab and is configured to use [Quad9](https://quad9.net/) as the upstream DNS provider. Two containerised Pi-hole instances are deployed. In the event of a failure of the primary Pi-hole, the secondary Pi-hole will take over as it is configured as the secondary DNS server on my router.

## :simple-pihole: Primary Pi-hole

The primary Pi-hole (`pihole01.net.dbren.uk`) instance is deployed on a Raspberry Pi 3 using [Docker](https://docs.docker.com/engine/install/).

### Raspberry Pi OS Setup

1. Flash Raspberry Pi OS Lite (64-bit) to a micro SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

2. Click the **cog icon** on the bottom right to open the *Advanced options* menu and configure the following options:

    - Set hostname to `pihole01`.
    - Enable SSH and allow public key authentication only. Enter your public key in the `authorized_keys` field.
    - Set a username and password.
    - Set locale settings as appropriate.
    - Disable telemetry.

3. Once flashed, insert the micro SD card into the Raspberry Pi and boot it.

4. SSH to the Raspberry Pi:

    !!! tip

        If you experience issues with hostname resolution on MacOS, try restarting the [mDNSResponder service](https://stackoverflow.com/questions/20252294/ssh-could-not-resolve-hostname-hostname-nodename-nor-servname-provided-or-n):

        ```
        sudo killall -HUP mDNSResponder
        ```

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
    nmcli connection modify eth0 ipv4.method manual ipv4.addresses 192.168.0.2/24 ipv4.gateway 192.168.0.1 ipv4.dns 9.9.9.9,149.112.112.112 connection.autoconnect yes

    # Enable connection to apply changes
    nmcli connection up eth0

    # Update system
    apt-get update && apt-get upgrade -y
    reboot
    ```

## :simple-pihole: Secondary Pi-hole

The secondary Pi-hole (`pihole02.net.dbren.uk`) is deployed on a Proxmox VM. The Proxmox VM is deployed using [OpenTofu](../infrastructure/opentofu.md). The deployment method for Pi-hole is identical to the primary.

## :simple-pihole: Managing DNS A and CNAME Records

An [Ansible playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/playbook-pihole-records.yml) is used to manage DNS A and CNAME records for both Pi-hole instances.

## :simple-tailscale: Tailscale

Both of the Pi-hole hosts are configured with [Tailscale](https://tailscale.com/) to provide ad-blocking whilst on the go. Tailscale is deployed using an [Ansible playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/playbook-tailscale.yml).

The following steps are to be performed once Tailscale has been configured on both the Pi-hole hosts:

1. Login to the Tailscale [admin portal](https://login.tailscale.com/admin/machines).

2. Copy the Tailnet IPs of `pihole01` and `pihole02`.

3. Select both machines in the portal and under machine settings, select **Disable key expiry**.

1. Go to your Tailnet's [DNS settings](https://login.tailscale.com/admin/dns) and under *Nameservers*, choose **Add nameserver** > **Custom...**.

2. Enter the Tailnet IPs of `pihole01` and `pihole02` and click **Save**.

3. Check **Override local DNS**.

Now when you connect to your Tailnet from your mobile device, you'll get Pi-hole ad-blocking! 🚀

Enjoy! ✨🚀
