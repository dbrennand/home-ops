# DNS

Pi-hole is used for DNS in my Homelab and is configured to use Cloudflare as an upstream DNS provider. Two Pi-hole instances are deployed, the primary Pi-hole is deployed on a Raspberry Pi 3 and the secondary Pi-hole is deployed on Proxmox as an LXC container.

In the event of a failure of the primary Pi-hole, the secondary Pi-hole will take over as it is configured as the secondary DNS server on my router.

## Primary Pi-hole

The primary Pi-hole is configured using [Ansible](https://homeops.danielbrennand.com/ansible/pihole/).

## Secondary Pi-hole

The secondary Pi-hole is configured using the [Pi-hole LXC](https://github.com/tteck/Proxmox/raw/main/ct/pihole.sh) script on Proxmox Node 2 (Secondary):

```bash
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/pihole.sh)"
```

I decided to use this script to avoid re-inventing the wheel and to learn more about LXC containers as at the time of writing this, I had no experience with LXC containers on Proxmox.

This script creates a Debian LXC container named `piholebak` and configures it to use the `vmbr0` bridge on Proxmox Node 2. The container is configured with the following resources:

| Setting           | Value           |
| ----------------- | --------------- |
| CPU Cores         | 1               |
| Memory            | 512.0MB         |
| Root Virtual Disk | `local-lvm` 2GB |
| Unprivileged      | True            |
| IP Address        | 192.168.0.5     |
| DNS Server        | 1.1.1.1         |

## Tailscale

Both Pi-hole instances are configured to use [Tailscale](https://tailscale.com/) to provide ad-blocking whilst on the go.

For the secondary Pi-hole, the LXC container must be [configured](https://tailscale.com/kb/1130/lxc-unprivileged#instructions) to allow Tailscale to run in an unprivileged container. This is done by adding the following lines to the `/etc/pve/lxc/<container-id>.conf` file on Proxmox Node 2:

```bash
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```

Once complete, restart the LXC container and perform the Tailscale installation using the [tailscale-playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/tailscale-playbook.yml).

## Synchronising Pi-hole Configuration

[Gravity-sync](https://github.com/vmstan/gravity-sync) is used to synchronise the Pi-hole configuration between the primary and secondary Pi-hole instances.

The following steps are taken from the gravity-sync [wiki](https://github.com/vmstan/gravity-sync/wiki):

1. Install gravity-sync on the primary and secondary Pi-hole instances:

    ```bash
    curl -sSL https://raw.githubusercontent.com/vmstan/gs-install/main/gs-install.sh | bash
    ```

2. Once installed and configured, on the primary and secondary Pi-hole instances run the command to compare the configuration:

    !!! note

        You should see in the output that `gravity-sync` has detected that the configuration is different.

    ```bash
    gravity-sync compare
    ```

3. On the **primary** Pi-hole instance **only**, run the command to push the configuration to the secondary Pi-hole instance:

    ```bash
    gravity-sync push
    ```

4. On the secondary Pi-hole instance verify the configuration has been replicated by running the compare command:

    ```bash
    gravity-sync compare
    ```

    You should see output similar to:

    ```
    ...
    ! No replication is required at this time
    ...
    ```

5. When the configuration has been verified, on the primary and secondary Pi-hole instances, run the command to enable automatic synchronisation:

    ```bash
    gravity-sync auto
    ```

    By default this command will configure a systemd service and timer to synchronise the Pi-hole configuration every ~5 minutes.

    You can use the following command to view the status of the systemd service:

    ```bash
    sudo systemctl status gravity-sync.service
    ```

If you ever need to modify the configuration of gravity-sync, you can do so by editing the `/etc/gravity-sync/gravity-sync.conf` file.
