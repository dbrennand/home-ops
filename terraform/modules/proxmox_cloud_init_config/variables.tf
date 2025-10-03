# OpenTofu Module - Proxmox Cloud Init Configuration - Variables
# LICENSE: MIT
# Author: Daniel Brennand

variable "proxmox_cloud_init_config_vm_name" {
  description = "Name of the Proxmox Virtual Machine."
  type        = string
}

variable "proxmox_cloud_init_config_virtual_environment_node_name" {
  description = "Name of the Proxmox VE node."
  type        = string
  default     = "proxmox01"
}

variable "proxmox_cloud_init_config_ssh_authorized_keys" {
  description = "SSH public key used by Cloud-init."
  type        = string
}

variable "proxmox_cloud_init_vm_username" {
  description = "Username to by provisioned by Cloud-init."
  type        = string
  default     = "daniel"
}
