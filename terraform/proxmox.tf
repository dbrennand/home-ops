# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.proxmox_virtual_environment.url
  username = "${data.onepassword_item.proxmox_virtual_environment.username}@pam"
  password = data.onepassword_item.proxmox_virtual_environment.password
}

module "proxmox_vm_exit01" {
  source                                           = "./modules/proxmox_vm"
  proxmox_vm_name                                  = "exit01"
  proxmox_vm_id                                    = 100
  proxmox_vm_tags                                  = ["vm", "opentofu", "tailscale"]
  proxmox_vm_cores                                 = 1
  proxmox_vm_memory                                = 1024
  proxmox_vm_ip                                    = "192.168.0.7/24"
  proxmox_vm_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
  proxmox_vm_virtual_environment_node_name         = "proxmox01"
  proxmox_vm_cloud_init_config_ssh_authorized_keys = data.onepassword_item.ssh_key.public_key
  proxmox_vm_disk_size                             = 50
}
