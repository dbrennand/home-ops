# OpenTofu Module - Proxmox LXC Container
# LICENSE: MIT
# Author: Daniel Brennand

terraform {
  required_version = ">= 1.6.2"
  # https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841/2
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.1"
    }
  }
}

locals {
  datetime                      = timestamp()
  proxmox_container_description = "Created by OpenTofu at ${local.datetime}"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file
resource "proxmox_virtual_environment_download_file" "latest_almalinux_9_qcow2_img" {
  content_type = "vztmpl"
  datastore_id = var.proxmox_container_download_file_datastore_id
  file_name    = var.proxmox_container_download_file_file_name
  node_name    = var.proxmox_container_virtual_environment_node_name
  url          = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.qcow2"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container
# Assumed default user is root
resource "proxmox_virtual_environment_container" "container" {
  vm_id       = var.proxmox_container_id
  description = local.proxmox_container_description
  tags        = var.proxmox_container_tags
  node_name   = var.proxmox_container_virtual_environment_node_name

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#cpu-2
  cpu {
    cores = var.proxmox_container_cores
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#memory-4
  memory {
    dedicated = var.proxmox_container_memory
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#initialization-2
  initialization {
    hostname = var.proxmox_container_hostname

    dns {
      domain  = var.proxmox_container_dns_domain
      servers = var.proxmox_container_dns_servers
    }

    ip_config {
      ipv4 {
        address = var.proxmox_container_ip
        gateway = var.proxmox_container_gateway
      }
    }

    user_account {
      keys     = var.proxmox_container_keys
      password = var.proxmox_container_password
    }
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#operating_system-2
  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.latest_almalinux_9_qcow2_img.id
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#started-1
  started = var.proxmox_container_started

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#start_on_boot-1
  start_on_boot = var.proxmox_container_start_on_boot

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#unprivileged-1
  unprivileged = var.proxmox_container_unprivileged

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#network_interface-1
  network_interface {
    name = "eth0"
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#disk-1
  disk {
    datastore_id = var.proxmox_container_disk_datastore_id
    size         = var.proxmox_container_disk_size
  }
}
