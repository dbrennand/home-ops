terraform {
  required_version = ">= 1.7.3"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.45.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "1.4.1"
    }
    external = {
      source = "hashicorp/external"
      version = "2.3.3"
    }
  }
}

# https://registry.terraform.io/providers/1Password/onepassword/latest/docs
provider "onepassword" {
  service_account_token = var.op_sa_token
}

data "onepassword_item" "virtual_environment" {
  vault = var.op_virtual_environment_vault_name
  title = var.op_virtual_environment_item_name
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

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.virtual_environment.url
  username = var.virtual_environment_username
  password = data.onepassword_item.virtual_environment.password
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "k3s_control" {
  for_each = {
    for node in var.control_nodes : node.name => node
  }

  name        = each.value.name
  description = each.value.description
  tags        = each.value.tags
  node_name   = var.virtual_environment_node

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#agent
  agent {
    enabled = true
    trim    = true
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#clone
  clone {
    vm_id = var.virtual_environment_template_vm_id
    # Equivalent to "Full Clone" and modifying the "Target Storage" in Proxmox UI
    datastore_id = var.virtual_environment_os_disk_datastore_id
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#cpu
  cpu {
    cores = each.value.cores
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#disk
  # Proxmox VM template already contains an OS disk of 50GB

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#memory
  memory {
    dedicated = each.value.memory
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#initialization
  initialization {
    datastore_id = var.virtual_environment_os_disk_datastore_id
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.nodes_gateway
      }
    }
    user_account {
      keys     = [trimspace(data.external.op_ssh_key.result["ssh_public_key"])]
      password = each.value.password
      username = each.value.username
    }
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#operating_system
  operating_system {
    type = "l26"
  }
}

resource "proxmox_virtual_environment_vm" "k3s_worker" {
  for_each = {
    for node in var.worker_nodes : node.name => node
  }

  name        = each.value.name
  description = each.value.description
  tags        = each.value.tags
  node_name   = var.virtual_environment_node

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#agent
  agent {
    enabled = true
    trim    = true
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#clone
  clone {
    vm_id = var.virtual_environment_template_vm_id
    # Equivalent to "Full Clone" and modifying the "Target Storage" in Proxmox UI
    datastore_id = var.virtual_environment_os_disk_datastore_id
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#cpu
  cpu {
    cores = each.value.cores
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#disk
  # Proxmox VM template already contains an OS disk of 50GB
  # Data disk for Longhorn
  disk {
    interface    = "virtio1"
    datastore_id = var.virtual_environment_data_disk_datastore_id
    discard      = "on"
    size         = 200
    file_format  = "raw"
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#memory
  memory {
    dedicated = each.value.memory
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#initialization
  initialization {
    datastore_id = var.virtual_environment_os_disk_datastore_id
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.nodes_gateway
      }
    }
    user_account {
      keys     = [trimspace(data.external.op_ssh_key.result["ssh_public_key"])]
      password = each.value.password
      username = each.value.username
    }
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#operating_system
  operating_system {
    type = "l26"
  }
}
