# OpenTofu Module - Proxmox Virtual Machine
# LICENSE: MIT
# Author: Daniel Brennand

terraform {
  required_version = ">= 1.6.2"
  # https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841/2
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.73.0"
    }
  }
}

locals {
  datetime               = timestamp()
  proxmox_vm_description = "Created by Terraform at ${local.datetime}"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file
resource "proxmox_virtual_environment_file" "cloud_init_config" {
  content_type = "snippets"
  # Local is the only datastore in my Homelab which supports the snippets content type
  datastore_id = "local"
  node_name    = var.proxmox_vm_virtual_environment_node_name
  source_raw = {
    data = <<EOF
#cloud-config
users:
  - name: daniel
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ${trimspace(var.proxmox_vm_cloud_init_config_ssh_authorized_keys)}
ssh_pwauth: false
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable --now qemu-guest-agent
  - timedatectl set-timezone Europe/London
EOF
  }
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file
resource "proxmox_virtual_environment_download_file" "latest_debian_bookworm_qcow2_img" {
  content_type       = "iso"
  datastore_id       = var.proxmox_vm_download_file_datastore_id
  node_name          = var.proxmox_vm_virtual_environment_node_name
  url                = "https://cloud.debian.org/images/cloud/bookworm/20250210-2019/debian-12-generic-amd64-20250210-2019.qcow2"
  checksum           = "56c236142b9e1427862dad62f7dfa727287599d361e7b71c22e3bd1c10e8a9f958fb820576cb5ec239bcb186cc2134b5742120c0b95aeeda68ed867bf206889a"
  checksum_algorithm = "sha512"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.proxmox_vm_name
  description = local.proxmox_vm_description
  tags        = var.proxmox_vm_tags
  node_name   = var.proxmox_vm_virtual_environment_node_name
  on_boot     = var.proxmox_vm_on_boot
  started     = var.proxmox_vm_started

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#agent
  agent {
    enabled = true
    trim    = true
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#cpu
  cpu {
    cores = var.proxmox_vm_cores
    type  = var.proxmox_vm_cpu_type
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#disk
  disk {
    interface    = "scsi0"
    datastore_id = var.proxmox_vm_virtual_environment_disk_datastore_id
    file_id      = proxmox_virtual_environment_download_file.latest_debian_bookworm_qcow2_img.id
    discard      = "on"
    size         = var.proxmox_vm_disk_size
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#memory
  memory {
    dedicated = var.proxmox_vm_memory
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#initialization
  initialization {
    datastore_id = var.proxmox_vm_virtual_environment_disk_datastore_id
    ip_config {
      ipv4 {
        address = var.proxmox_vm_ip
        gateway = var.proxmox_vm_gateway
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_config.id
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#operating_system
  operating_system {
    type = var.proxmox_vm_os_type
  }
}
