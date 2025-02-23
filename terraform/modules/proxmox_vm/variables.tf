# OpenTofu Module - Proxmox Virtual Machine - Variables
# LICENSE: MIT
# Author: Daniel Brennand

variable "proxmox_vm_name" {
  description = "Name of the Proxmox Virtual Machine."
  type        = string
}

variable "proxmox_vm_tags" {
  description = "Tags for the Proxmox Virtual Machine."
  type        = list(string)
  default     = ["vm"]
}

variable "proxmox_vm_cores" {
  description = "Number of CPU cores for the Proxmox Virtual Machine."
  type        = number
  default     = 2
}

variable "proxmox_vm_cpu_type" {
  description = "Type of CPU for the Proxmox Virtual Machine."
  type        = string
  default     = "host"
}

variable "proxmox_vm_memory" {
  description = "Amount of memory for the Proxmox Virtual Machine."
  type        = number
  default     = 2048
}

variable "proxmox_vm_ip" {
  description = "IP address for the Proxmox Virtual Machine."
  type        = string
}

variable "proxmox_vm_gateway" {
  description = "Gateway IP address for the Proxmox Virtual Machine."
  type        = string
  default     = "192.168.0.1"
}

variable "proxmox_vm_keys" {
  description = "SSH keys for the Proxmox Virtual Machine."
  type        = list(string)
  default     = []
}

variable "proxmox_vm_username" {
  description = "Username for the Proxmox Virtual Machine."
  type        = string
}

variable "proxmox_vm_password" {
  description = "Password for the Proxmox Virtual Machine."
  type        = string
  sensitive   = true
}

variable "proxmox_virtual_environment_template_vm_id" {
  description = "ID of the Proxmox VE template Virtual Machine used for cloning."
  type        = number
  default     = 9000
}

variable "proxmox_virtual_environment_template_vm_node_name" {
  description = "Name of the Proxmox VE node where the template Virtual Machine resides on."
  type        = string
  default     = "proxmox01"
}

variable "proxmox_virtual_environment_disk_datastore_id" {
  description = "ID of the Proxmox VE datastore used for the Virtual Machine disk."
  type        = string
  default     = "local-lvm"
}

variable "proxmox_virtual_environment_node_name" {
  description = "Name of the Proxmox VE node."
  type        = string
  default     = "proxmox01"
}

variable "proxmox_vm_os_type" {
  description = "Type of operating system for the Proxmox Virtual Machine."
  type        = string
  default     = "l26"
}
