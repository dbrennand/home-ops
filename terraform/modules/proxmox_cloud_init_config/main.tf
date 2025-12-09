# OpenTofu Module - Proxmox Cloud Init Configuration
# LICENSE: MIT
# Author: Daniel Brennand
# Description: Create a Proxmox Cloud Init Configuration file for a Virtual Machine.

terraform {
  required_version = ">= 1.10.6"
  # https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841/2
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.89.1"
    }
  }
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file
resource "proxmox_virtual_environment_file" "cloud_init_config" {
  content_type = "snippets"
  # Local is the only datastore in my Homelab which supports the snippets content type
  datastore_id = "local"
  node_name    = var.proxmox_cloud_init_config_virtual_environment_node_name
  source_raw {
    file_name = "cloud-init-config-${var.proxmox_cloud_init_config_vm_name}.yaml"
    data      = <<EOF
#cloud-config
hostname: ${var.proxmox_cloud_init_config_vm_name}
users:
  - name: ${var.proxmox_cloud_init_vm_username}
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ${trimspace(var.proxmox_cloud_init_config_ssh_authorized_keys)}
ssh_pwauth: false
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
  - openssh-server
runcmd:
  - systemctl enable --now qemu-guest-agent
  - systemctl enable --now sshd
  - timedatectl set-timezone Europe/London
  - hostnamectl set-hostname ${var.proxmox_cloud_init_config_vm_name}
EOF
  }
}

output "cloud_init_config_id" {
  value = proxmox_virtual_environment_file.cloud_init_config.id
}
