# :simple-raspberrypi: Raspberry Pi 3

!!! note "Archived"

    This page has been archived and kept for reference. Some of the links on this page may no longer work.

A Raspberry Pi 3 is used in my Homelab as a Tailscale [subnet router](https://tailscale.com/kb/1019/subnets) and [exit node](https://tailscale.com/kb/1103/exit-nodes).

## Raspberry Pi 3 OS Setup

1. Flash Raspberry Pi OS Lite (64-bit) to a micro SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

2. Click the **cog icon** on the bottom right to open the *Advanced options* menu and configure the following options:

    - Set hostname to `subnet01`.
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
    ssh <user>@subnet01.net.dbren.uk
    ```

5. Run the following commands on the Raspberry Pi to set a static IP address, update the system and expand the filesystem:

    ```bash
    # Become root
    sudo -i
    raspi-config
    # Select "Advanced Options" > "Network Config" > 2 NetworkManager
    # Select "Advanced Options" > "Expand Filesystem"

    # Set static IP address
    nmcli connection modify eth0 ipv4.method manual ipv4.addresses 192.168.0.2/24 ipv4.gateway 192.168.0.1 ipv4.dns 45.90.28.138,45.90.30.138 connection.autoconnect yes

    # Enable connection to apply changes
    nmcli connection up eth0

    # Update system
    apt-get update && apt-get upgrade -y
    reboot
    ```
