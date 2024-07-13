# OpenTofu Module - Proxmox Virtual Machine
# LICENSE: MIT
# Author: Daniel Brennand

terraform {
  required_version = ">= 1.6.2"
  # https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841/2
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.61.1"
    }
  }
}

locals {
  datetime               = timestamp()
  proxmox_vm_description = "Created by Terraform at ${local.datetime}"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.proxmox_vm_name
  description = local.proxmox_vm_description
  tags        = var.proxmox_vm_tags
  node_name   = var.proxmox_virtual_environment_node_name

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#agent
  agent {
    enabled = true
    trim    = true
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#clone
  clone {
    vm_id = var.proxmox_virtual_environment_template_vm_id
    node_name = var.proxmox_virtual_environment_template_vm_node_name
    # Equivalent to "Full Clone" and modifying the "Target Storage" in Proxmox UI
    datastore_id = var.proxmox_virtual_environment_disk_datastore_id
    # Error: error waiting for VM clone: All attempts fail
    # HTTP 599 response - Reason: Too many redirections
    retries = 4
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#cpu
  cpu {
    cores = var.proxmox_vm_cores
    type  = var.proxmox_vm_cpu_type
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#disk
  #disk {
  #  interface    = "virtio0"
  #  datastore_id = var.virtual_environment_disk_datastore_id
  #  discard      = "on"
  #  size         = 50
  #  file_format  = "raw"
  #}

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#memory
  memory {
    dedicated = var.proxmox_vm_memory
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#initialization
  initialization {
    datastore_id = var.proxmox_virtual_environment_disk_datastore_id
    ip_config {
      ipv4 {
        address = var.proxmox_vm_ip
        gateway = var.proxmox_vm_gateway
      }
    }
    user_account {
      keys = var.proxmox_vm_keys
      username = var.proxmox_vm_username
      password = var.proxmox_vm_password
    }
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#operating_system
  operating_system {
    type = var.proxmox_vm_os_type
  }
}
