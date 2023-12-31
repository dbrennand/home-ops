terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.38.1"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "1.3.0"
    }
  }
}

locals {
  datetime       = timestamp()
  vm_description = "Created by Terraform on ${local.datetime}"
}

# https://registry.terraform.io/providers/1Password/onepassword/latest/docs
provider "onepassword" {
  service_account_token = var.op_sa_token
}

data "onepassword_item" "virtual_environment" {
  vault = var.op_virtual_environment_vault_name
  title = var.op_virtual_environment_item_name
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.virtual_environment.url
  username = var.virtual_environment_username
  password = data.onepassword_item.virtual_environment.password
  insecure = true
}

# https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external
# 1Password Terraform provider does not support retrieving SSH keys yet :(
# https://github.com/1Password/terraform-provider-onepassword/issues/74
data "external" "op_ssh_key" {
  program = ["../hack/op-ssh.sh"]
  query = {
    vault = var.op_ssh_vault_name
    title = var.op_ssh_key_name
  }
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "common" {
  name        = var.vm_name
  description = local.vm_description
  tags        = var.vm_tags
  node_name   = var.virtual_environment_node

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#agent
  agent {
    enabled = true
    trim    = true
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#clone
  clone {
    vm_id = var.virtual_environment_template_vm_id
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#cpu
  cpu {
    cores = var.vm_cores
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
    dedicated = var.vm_memory
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#initialization
  initialization {
    ip_config {
      ipv4 {
        address = var.vm_ip
        gateway = var.vm_gateway
      }
    }
    user_account {
      keys     = [trimspace(data.external.op_ssh_key.result["ssh_public_key"])]
      username = var.vm_username
      password = var.vm_password
    }
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#operating_system
  operating_system {
    type = "l26"
  }
}
