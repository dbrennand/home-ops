# Ansible

The Ansible playbooks in this repository are used to configure my Homelab servers and deploy applications.

## Playbooks

| Playbook                                                                         | Description                                |
| -------------------------------------------------------------------------------- | ------------------------------------------ |
| [minecraft-playbook.yml](playbooks/minecraft-playbook.yml)                       | Deploy Minecraft server.                   |
| [proxmox-create-vm-template.yml](playbooks/proxmox-create-vm-template.yml)       | Create VM templates.                       |
| [proxmox-download-iso-playbook.yml](playbooks/proxmox-download-iso-playbook.yml) | Download ISOs to Proxmox.                  |
| [proxmox-storage-playbook.yml](playbooks/proxmox-storage-playbook.yml)           | Provision Proxmox LVM Storage.             |
| [proxmox-external-vote.yml](playbooks/proxmox-external-vote.yml)                 | Cluster External Vote Support.             |
| [pihole-playbook.yml](playbooks/pihole-playbook.yml)                             | Deploy Pi-hole on Raspberry Pi 3.          |
| [tailscale-playbook.yml](playbooks/tailscale-playbook.yml)                       | Install or update Tailscale.               |
| [lxc-journald-playbook.yml](playbooks/lxc-journald-playbook.yml)                 | Configure LXC containers journald logging. |
| [setup-playbook.yml](playbooks/setup-playbook.yml)                               | General setup for new servers.             |
| [proxmox-backup-cifs.yml](playbooks/proxmox-backup-cifs.yml)                     | Mount CIFS share on Proxmox Backup server. |
| [media-playbook.yml](playbooks/media-playbook.yml)                               | Media server setup.                        |
