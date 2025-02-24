# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.proxmox_virtual_environment.url
  username = "${data.onepassword_item.proxmox_virtual_environment.username}@pam"
  password = data.onepassword_item.proxmox_virtual_environment.password
}

module "proxmox_lxc_exit01" {
  source                                          = "./modules/proxmox_lxc"
  proxmox_container_virtual_environment_node_name = "proxmox01"
  proxmox_container_id                            = 900
  proxmox_container_tags                          = ["lxc", "opentofu", "tailscale", "192.168.0.7"]
  proxmox_container_hostname                      = "exit01"
  proxmox_container_dns_domain                    = "net.dbren.uk"
  proxmox_container_ip                            = "192.168.0.7/24"
  proxmox_container_keys                          = [trimspace(data.onepassword_item.ssh_key.public_key)]
  proxmox_container_password                      = data.onepassword_item.exit01.password
  proxmox_container_started                       = false
  proxmox_container_disk_datastore_id             = "lv-ssd-crucial"
  proxmox_container_disk_size                     = 2
}

module "proxmox_lxc_exit02" {
  source                                          = "./modules/proxmox_lxc"
  proxmox_container_virtual_environment_node_name = "proxmox02"
  proxmox_container_id                            = 901
  proxmox_container_tags                          = ["lxc", "opentofu", "tailscale", "192.168.0.8"]
  proxmox_container_hostname                      = "exit02"
  proxmox_container_dns_domain                    = "net.dbren.uk"
  proxmox_container_ip                            = "192.168.0.8/24"
  proxmox_container_keys                          = [trimspace(data.onepassword_item.ssh_key.public_key)]
  proxmox_container_password                      = data.onepassword_item.exit02.password
  proxmox_container_started                       = false
  proxmox_container_disk_datastore_id             = "local-lvm"
  proxmox_container_disk_size                     = 2
}
