# :fontawesome-brands-raspberry-pi: Raspberry Pi OS Setup

These steps provide the initial configuration for a Raspberry Pi that will be
managed by Ansible.

## Raspberry Pi OS setup

1. Flash Raspberry Pi OS Lite (64-bit) to an SSD connected over USB using
   [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

2. Select the cog icon to open the advanced options and configure the
   following settings:

   - Set the hostname to the hostname of the host to be deployed.
   - Enable SSH and allow public key authentication only. Enter the public key
     that will be used to connect to the host.
   - Set a username and password.
   - Set the locale settings as appropriate.
   - Disable telemetry.

3. Connect the SSD to the Raspberry Pi over USB and boot it.

4. Find the Raspberry Pi's IP address by scanning the local network:

    ```bash
    sudo nmap -sn 192.168.0.1/24
    ```

5. SSH to the Raspberry Pi using the configured username and hostname or IP
   address:

    ```bash
    ssh <username>@<hostname>
    ```

    !!! note

        If hostname resolution does not work, use the Raspberry Pi's IP
        address or resolve the hostname. You may need to restart the mDNS
        service on macOS:

        ```bash
        sudo killall -HUP mDNSResponder
        ```

6. Run the following commands on the Raspberry Pi to configure its static
   network address and update the system:

    ```bash
    # Network configuration
    INTERFACE="eth0"
    IP_ADDRESS="192.168.0.2/24"
    GATEWAY="192.168.0.1"
    DNS_SERVERS="45.90.28.138,45.90.30.138"

    # Set the static IP address
    sudo nmcli connection modify "${INTERFACE}" \
      ipv4.method manual \
      ipv4.addresses "${IP_ADDRESS}" \
      ipv4.gateway "${GATEWAY}" \
      ipv4.dns "${DNS_SERVERS}" \
      connection.autoconnect yes

    # Apply the network configuration
    sudo nmcli connection up "${INTERFACE}"

    # Update the system
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo reboot
    ```
