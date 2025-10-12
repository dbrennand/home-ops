# https://registry.terraform.io/providers/bpg/proxmox/latest/docs
provider "proxmox" {
  endpoint = data.onepassword_item.proxmox_virtual_environment.url
  username = "${data.onepassword_item.proxmox_virtual_environment.username}@pam"
  password = data.onepassword_item.proxmox_virtual_environment.password
  ssh {
    agent = true
  }
}

module "proxmox_vm_pihole02" {
  source                                           = "./modules/proxmox_vm"
  proxmox_vm_name                                  = "pihole02"
  proxmox_vm_id                                    = 100
  proxmox_vm_tags                                  = ["vm", "opentofu", "192.168.0.5"]
  proxmox_vm_cores                                 = 2
  proxmox_vm_memory                                = 2048
  proxmox_vm_ip                                    = "192.168.0.5/24"
  proxmox_vm_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
  proxmox_vm_virtual_environment_node_name         = "proxmox01"
  proxmox_vm_cloud_init_config_ssh_authorized_keys = data.onepassword_item.ssh_key.public_key
  proxmox_vm_disk_size                             = 50
  proxmox_vm_started                               = true
}

module "proxmox_vm_exit01" {
  source                                           = "./modules/proxmox_vm"
  proxmox_vm_name                                  = "exit01"
  proxmox_vm_id                                    = 101
  proxmox_vm_tags                                  = ["vm", "opentofu", "tailscale", "192.168.0.7"]
  proxmox_vm_cores                                 = 2
  proxmox_vm_memory                                = 2048
  proxmox_vm_ip                                    = "192.168.0.7/24"
  proxmox_vm_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
  proxmox_vm_virtual_environment_node_name         = "proxmox01"
  proxmox_vm_cloud_init_config_ssh_authorized_keys = data.onepassword_item.ssh_key.public_key
  proxmox_vm_disk_size                             = 50
  proxmox_vm_started                               = true
}

module "proxmox_vm_exit02" {
  source                                           = "./modules/proxmox_vm"
  proxmox_vm_name                                  = "exit02"
  proxmox_vm_id                                    = 104
  proxmox_vm_tags                                  = ["vm", "opentofu", "tailscale", "192.168.0.8"]
  proxmox_vm_cores                                 = 2
  proxmox_vm_memory                                = 2048
  proxmox_vm_ip                                    = "192.168.0.8/24"
  proxmox_vm_virtual_environment_disk_datastore_id = "local-lvm"
  proxmox_vm_virtual_environment_node_name         = "proxmox02"
  proxmox_vm_cloud_init_config_ssh_authorized_keys = data.onepassword_item.ssh_key.public_key
  proxmox_vm_disk_size                             = 50
  proxmox_vm_started                               = true
}

module "proxmox_vm_k3s01" {
  source                                           = "./modules/proxmox_vm"
  proxmox_vm_name                                  = "k3s01"
  proxmox_vm_id                                    = 105
  proxmox_vm_tags                                  = ["vm", "opentofu", "tailscale", "192.168.0.10"]
  proxmox_vm_cores                                 = 4
  proxmox_vm_memory                                = 8192
  proxmox_vm_ip                                    = "192.168.0.10/24"
  proxmox_vm_virtual_environment_disk_datastore_id = "lv-ssd-crucial"
  proxmox_vm_virtual_environment_node_name         = "proxmox01"
  proxmox_vm_cloud_init_config_ssh_authorized_keys = data.onepassword_item.ssh_key.public_key
  proxmox_vm_disk_size                             = 100
  proxmox_vm_started                               = true
}

# Below content is Proxmox resources provisioned on or after 12 October 2025
# I've found that my proxmox_vm module is to restrictive and I have deprecated it

resource "proxmox_virtual_environment_download_file" "almalinux_9_latest_cloud_image" {
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = "proxmox01"
  file_name          = "AlmaLinux-9-GenericCloud-latest.x86_64.qcow2.img"
  url                = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
  checksum           = "b08cd5db79bf32860412f5837e8c7b8df9447e032376e3c622840b31aaf26bc6"
  checksum_algorithm = "sha256"
}

module "proxmox_cloud_init_config_idp01" {
  source                                                  = "./modules/proxmox_cloud_init_config"
  proxmox_cloud_init_config_vm_name                       = "idp01"
  proxmox_cloud_init_config_virtual_environment_node_name = "proxmox01"
  proxmox_cloud_init_config_ssh_authorized_keys           = data.onepassword_item.ssh_key.public_key
}

resource "proxmox_virtual_environment_vm" "idp01" {
  name        = "idp01"
  vm_id       = 106
  description = "Created with OpenTofu."
  tags        = ["vm", "opentofu", "tailscale", "192.168.0.11"]
  node_name   = "proxmox01"
  on_boot     = false
  started     = true

  agent {
    enabled = true
    trim    = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  scsi_hardware = "virtio-scsi-single"

  disk {
    interface    = "scsi0"
    datastore_id = "lv-ssd-crucial"
    file_id      = proxmox_virtual_environment_download_file.almalinux_9_latest_cloud_image.id
    size         = 50
    discard      = "on"
    ssd          = true
    iothread     = true
  }

  memory {
    dedicated = 2048
  }

  initialization {
    datastore_id = "lv-ssd-crucial"
    ip_config {
      ipv4 {
        address = "192.168.0.11/24"
        gateway = "192.168.0.1"
      }
    }
    user_data_file_id = module.proxmox_cloud_init_config_idp01.cloud_init_config_id
  }

  operating_system {
    type = "l26"
  }

  network_device {
    bridge   = "vmbr0"
    enabled  = true
    firewall = true
  }
}
