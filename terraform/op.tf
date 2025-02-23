# https://registry.terraform.io/providers/1Password/onepassword/latest/docs
provider "onepassword" {
  service_account_token = var.op_sa_token
}

# https://registry.terraform.io/providers/1Password/onepassword/latest/docs/data-sources/item
data "onepassword_item" "proxmox_virtual_environment" {
  vault = var.op_proxmox_virtual_environment_vault_name
  title = var.op_proxmox_virtual_environment_item_name
}

data "onepassword_item" "ssh_key" {
  vault = var.op_ssh_vault_name
  title = var.op_ssh_key_name
}

data "onepassword_item" "exit01" {
  vault = var.op_exit01_vault_name
  title = var.op_exit01_item_name
}
