# OpenTofu Module - Proxmox LXC
# LICENSE: MIT
# Author: Daniel Brennand

terraform {
  required_version = ">= 1.6.2"
  # https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841/2
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.96.0"
    }
  }
}

locals {
  datetime                      = timestamp()
  proxmox_container_description = "Created by OpenTofu at ${local.datetime}"
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file
resource "proxmox_virtual_environment_download_file" "latest_almalinux_vztmpl" {
  content_type       = "vztmpl"
  datastore_id       = var.proxmox_container_download_file_datastore_id
  node_name          = var.proxmox_container_virtual_environment_node_name
  file_name          = "almalinux-9-cloud_amd64.tar.xz"
  url                = "https://images.linuxcontainers.org/images/almalinux/9/amd64/cloud/20250223_23:08/rootfs.tar.xz"
  checksum           = "d593648a6a3a3ba6bd8a410e1d3e1688bf12f4fa9e62dcf31aedb8cf729313e5"
  checksum_algorithm = "sha256"
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
    dedicated = var.proxmox_container_memory_dedicated
    swap      = var.proxmox_container_memory_swap
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
    template_file_id = proxmox_virtual_environment_download_file.latest_almalinux_vztmpl.id
    type             = "centos"
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

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container#features-2
  features {
    keyctl  = true
    nesting = true
  }
}
