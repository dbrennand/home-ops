# OpenTofu Module - Proxmox Virtual Machine - Variables
# LICENSE: MIT
# Author: Daniel Brennand

variable "proxmox_vm_id" {
  description = "ID of the Proxmox Virtual Machine."
  type        = number
}

variable "proxmox_vm_name" {
  description = "Name of the Proxmox Virtual Machine."
  type        = string
}

variable "proxmox_vm_tags" {
  description = "Tags for the Proxmox Virtual Machine."
  type        = list(string)
  default     = ["vm", "opentofu"]
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
  description = "Amount of memory for the Proxmox Virtual Machine in megabytes."
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

variable "proxmox_vm_virtual_environment_disk_datastore_id" {
  description = "ID of the Proxmox VE datastore used for the Virtual Machine disk."
  type        = string
  default     = "local-lvm"
}

variable "proxmox_vm_virtual_environment_node_name" {
  description = "Name of the Proxmox VE node."
  type        = string
  default     = "proxmox01"
}

variable "proxmox_vm_os_type" {
  description = "Type of operating system for the Proxmox Virtual Machine."
  type        = string
  default     = "l26"
}

variable "proxmox_vm_cloud_init_config_ssh_authorized_keys" {
  description = "SSH public key used by Cloud-init."
  type        = string
}

variable "proxmox_vm_download_file_datastore_id" {
  description = "ID of the Proxmox VE datastore used for the Debian qcow2 image."
  type        = string
  default     = "local"
}

variable "proxmox_vm_on_boot" {
  description = "Start the Proxmox Virtual Machine when the Proxmox node boots."
  type        = bool
  default     = false
}

variable "proxmox_vm_started" {
  description = "Start the Proxmox Virtual Machine after the VM is created."
  type        = bool
  default     = false
}

variable "proxmox_vm_disk_size" {
  description = "Size of the Proxmox Virtual Machine disk in gigabytes."
  type        = number
  default     = 50
}
