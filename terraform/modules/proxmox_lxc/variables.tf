# OpenTofu Module - Proxmox LXC Container - Variables
# LICENSE: MIT
# Author: Daniel Brennand

variable "proxmox_container_download_file_datastore_id" {
  description = "Name of the Proxmox Datastore to save the qcow2 image to."
  type        = string
  default     = "local"
}

variable "proxmox_container_virtual_environment_node_name" {
  description = "Name of the Proxmox VE node."
  type        = string
  default     = "proxmox01"
}

variable "proxmox_container_id" {
  description = "ID of the Proxmox LXC Container."
  type        = number
}

variable "proxmox_container_tags" {
  description = "Tags for the Proxmox LXC Container."
  type        = list(string)
  default     = ["lxc"]
}

variable "proxmox_container_cores" {
  description = "Number of CPU cores for the Proxmox LXC Container."
  type        = number
  default     = 1
}

variable "proxmox_container_memory" {
  description = "Amount of memory for the Proxmox LXC Container."
  type        = number
  default     = 2048
}

variable "proxmox_container_hostname" {
  description = "Hostname for the Proxmox LXC Container."
  type        = string
}

variable "proxmox_container_dns_domain" {
  description = "DNS search domain for the Proxmox LXC Container."
  type        = string
}

variable "proxmox_container_dns_servers" {
  description = "DNS servers for the Proxmox LXC Container."
  type        = list(string)
  default     = ["192.168.0.2"]
}

variable "proxmox_container_ip" {
  description = "IP address for the Proxmox LXC Container."
  type        = string
}

variable "proxmox_container_gateway" {
  description = "Gateway IP address for the Proxmox LXC Container."
  type        = string
  default     = "192.168.0.1"
}

variable "proxmox_container_keys" {
  description = "SSH keys for the Proxmox LXC Container."
  type        = list(string)
  default     = []
}

variable "proxmox_container_password" {
  description = "Password for the Proxmox LXC Container."
  type        = string
  sensitive   = true
}

variable "proxmox_container_started" {
  description = "Boolean to start the Proxmox LXC Container once created."
  type        = bool
  default     = false
}

variable "proxmox_container_start_on_boot" {
  description = "Boolean to start the Proxmox LXC Container once the Proxmox node boots."
  type        = bool
  default     = false
}

variable "proxmox_container_unprivileged" {
  description = "Boolean to specify whether the Proxmox LXC Container is unprivileged or not."
  type        = bool
  default     = true
}

variable "proxmox_container_disk_datastore_id" {
  description = "ID of the Proxmox datastore to store the Proxmox LXC Container disk."
  type        = string
  default     = "local-lvm"
}

variable "proxmox_container_disk_size" {
  description = "Size of the Proxmox LXC Container disk in Gigabytes."
  type        = number
  default     = 4
}
