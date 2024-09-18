# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.proxmox_virtual_environment.url
  username = "${data.onepassword_item.proxmox_virtual_environment.username}@pam"
  password = data.onepassword_item.proxmox_virtual_environment.password
}

# Proxmox VMs

#module "proxmox_vm_docker01" {
#  source                                        = "./modules/proxmox_vm"
#  proxmox_vm_name                               = "docker01"
#  proxmox_vm_username                           = data.onepassword_item.docker01.username
#  proxmox_vm_password                           = data.onepassword_item.docker01.password
#  proxmox_vm_ip                                 = "192.168.0.12/24"
#  proxmox_vm_keys                               = [trimspace(data.onepassword_item.op_ssh_key.public_key)]
#  proxmox_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
#  proxmox_vm_tags                               = ["vm", "tailscale", "docker"]
#  proxmox_vm_cores                              = 4
#  # 8GB
#  proxmox_vm_memory = 8192
#}
