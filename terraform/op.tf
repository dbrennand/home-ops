# https://registry.terraform.io/providers/1Password/onepassword/latest/docs
provider "onepassword" {
  service_account_token = var.op_sa_token
}

# https://registry.terraform.io/providers/1Password/onepassword/latest/docs/data-sources/item
data "onepassword_item" "proxmox_virtual_environment" {
  vault = var.op_proxmox_virtual_environment_vault_name
  title = var.op_proxmox_virtual_environment_item_name
}

data "onepassword_item" "pihole" {
  vault = var.op_pihole_vault_name
  title = var.op_pihole_item_name
}

data "onepassword_item" "control01" {
  vault = var.op_proxmox_virtual_environment_vault_name
  title = "control01.net.dbren.uk"
}

data "onepassword_item" "worker01" {
  vault = var.op_proxmox_virtual_environment_vault_name
  title = "worker01.net.dbren.uk"
}

data "onepassword_item" "worker02" {
  vault = var.op_proxmox_virtual_environment_vault_name
  title = "worker02.net.dbren.uk"
}
