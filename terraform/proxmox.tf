# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.proxmox_virtual_environment.url
  username = "${data.onepassword_item.proxmox_virtual_environment.username}@pam"
  password = data.onepassword_item.proxmox_virtual_environment.password
}

# Proxmox VMs

module "proxmox_vm_control01" {
  source                                        = "./modules/proxmox_vm"
  proxmox_vm_name                               = "control01"
  proxmox_vm_username                           = data.onepassword_item.control01.username
  proxmox_vm_password                           = data.onepassword_item.control01.password
  proxmox_vm_ip                                 = "192.168.0.12/24"
  proxmox_vm_keys                               = [trimspace(data.external.op_ssh_key.result["ssh_public_key"])]
  proxmox_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
  proxmox_vm_tags                               = ["vm", "k8s"]
  proxmox_vm_cores                              = 4
  # 8GB
  proxmox_vm_memory = 8192
}

module "proxmox_vm_worker01" {
  source                                        = "./modules/proxmox_vm"
  proxmox_vm_name                               = "worker01"
  proxmox_vm_username                           = data.onepassword_item.worker01.username
  proxmox_vm_password                           = data.onepassword_item.worker01.password
  proxmox_vm_ip                                 = "192.168.0.13/24"
  proxmox_vm_keys                               = [trimspace(data.external.op_ssh_key.result["ssh_public_key"])]
  proxmox_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
  proxmox_vm_tags                               = ["vm", "k8s"]
  # 4GB
  proxmox_vm_memory = 4096
}

module "proxmox_vm_worker02" {
  source                                        = "./modules/proxmox_vm"
  proxmox_vm_name                               = "worker02"
  proxmox_vm_username                           = data.onepassword_item.worker02.username
  proxmox_vm_password                           = data.onepassword_item.worker02.password
  proxmox_vm_ip                                 = "192.168.0.14/24"
  proxmox_vm_keys                               = [trimspace(data.external.op_ssh_key.result["ssh_public_key"])]
  proxmox_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
  proxmox_vm_tags                               = ["vm", "k8s"]
  # 4GB
  proxmox_vm_memory = 4096
}
