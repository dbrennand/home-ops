## Post Installation

!!! warning

    Proceed with caution, before running any of the scripts below, make sure to review the code to ensure it is safe to run.

1. Run the [Proxmox VE post install](https://github.com/tteck/Proxmox) script:

    ```bash
    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pve-install.sh)"
    ```

2. Run the [Proxmox Dark Theme](https://github.com/Weilbyte/PVEDiscordDark) script:

    ```bash
    bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install
    ```

3. Extend the Proxmox `data` logical volume to use the remaining space on the disk:

    ```bash
    lvextend -l +100%FREE /dev/pve/data
    ```
