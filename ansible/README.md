# Ansible

The Ansible playbooks in this repository are used to configure my Homelab servers and deploy applications.

## Playbooks

| Playbook                                                               | Description                                |
| ---------------------------------------------------------------------- | ------------------------------------------ |
| [minecraft-playbook.yml](playbooks/minecraft-playbook.yml)             | Deploy Minecraft server.                   |
| [proxmox-storage-playbook.yml](playbooks/proxmox-storage-playbook.yml) | Provision Proxmox LVM Storage.             |
| [proxmox-external-vote.yml](playbooks/proxmox-external-vote.yml)       | Cluster External Vote Support.             |
| [tailscale-playbook.yml](playbooks/tailscale-playbook.yml)             | Install or update Tailscale.               |
| [setup-playbook.yml](playbooks/setup-playbook.yml)                     | General setup for new servers.             |
| [proxmox-backup-cifs.yml](playbooks/proxmox-backup-cifs.yml)           | Mount CIFS share on Proxmox Backup server. |
| [media-playbook.yml](playbooks/media-playbook.yml)                     | Media server setup.                        |
