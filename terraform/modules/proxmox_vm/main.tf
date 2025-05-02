# OpenTofu Module - Proxmox Virtual Machine
# LICENSE: MIT
# Author: Daniel Brennand

terraform {
  required_version = ">= 1.6.2"
  # https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841/2
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.77.0"
    }
  }
}

locals {
  datetime               = timestamp()
  proxmox_vm_description = "Created by OpenTofu at ${local.datetime}"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file
resource "proxmox_virtual_environment_file" "cloud_init_config" {
  content_type = "snippets"
  # Local is the only datastore in my Homelab which supports the snippets content type
  datastore_id = "local"
  node_name    = var.proxmox_vm_virtual_environment_node_name
  source_raw {
    file_name = "cloud-init-config-${var.proxmox_vm_name}.yaml"
    data      = <<EOF
#cloud-config
hostname: ${var.proxmox_vm_name}
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
  - openssh-server
runcmd:
  - systemctl enable --now qemu-guest-agent
  - systemctl enable --now sshd
  - timedatectl set-timezone Europe/London
  - hostnamectl set-hostname ${var.proxmox_vm_name}
EOF
  }
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file
resource "proxmox_virtual_environment_download_file" "latest_almalinux_qcow2_img" {
  content_type       = "iso"
  datastore_id       = var.proxmox_vm_download_file_datastore_id
  node_name          = var.proxmox_vm_virtual_environment_node_name
  file_name          = "AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.qcow2.img"
  url                = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.qcow2"
  checksum           = "abddf01589d46c841f718cec239392924a03b34c4fe84929af5d543c50e37e37"
  checksum_algorithm = "sha256"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.proxmox_vm_name
  vm_id       = var.proxmox_vm_id
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

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#scsi_hardware-1
  scsi_hardware = "virtio-scsi-single"

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#disk
  disk {
    interface    = "scsi0"
    datastore_id = var.proxmox_vm_virtual_environment_disk_datastore_id
    file_id      = proxmox_virtual_environment_download_file.latest_almalinux_qcow2_img.id
    discard      = "on"
    size         = var.proxmox_vm_disk_size
    ssd          = true
    iothread     = true
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

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#network_device-1
  network_device {
    bridge   = "vmbr0"
    enabled  = true
    firewall = true
  }
}
