# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.proxmox_virtual_environment.url
  username = "${data.onepassword_item.proxmox_virtual_environment.username}@pam"
  password = data.onepassword_item.proxmox_virtual_environment.password
}
