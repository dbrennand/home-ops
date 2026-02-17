# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.proxmox_virtual_environment.url
  username = "${data.onepassword_item.proxmox_virtual_environment.username}@pam"
  password = data.onepassword_item.proxmox_virtual_environment.password
  ssh {
    agent = true
  }
}

resource "proxmox_virtual_environment_download_file" "almalinux_9_latest_cloud_image" {
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = "proxmox01"
  file_name          = "AlmaLinux-9-GenericCloud-latest.x86_64.qcow2.img"
  url                = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
  checksum           = "5ff9c048859046f41db4a33b1f1a96675711288078aac66b47d0be023af270d1"
  checksum_algorithm = "sha256"
}

module "proxmox_cloud_init_config_idp01" {
  source                                                  = "./modules/proxmox_cloud_init_config"
  proxmox_cloud_init_config_vm_name                       = "idp01"
  proxmox_cloud_init_config_virtual_environment_node_name = "proxmox01"
  proxmox_cloud_init_config_ssh_authorized_keys           = data.onepassword_item.ssh_key.public_key
}
