variable "op_proxmox_virtual_environment_vault_name" {
  description = "1Password vault name containing the Proxmox virtual environment item."
  type        = string
  default     = "Home-Ops"
}

variable "op_proxmox_virtual_environment_item_name" {
  description = "1Password Proxmox virtual environment item name."
  type        = string
  default     = "proxmox01.net.dbren.uk"
}

variable "op_ssh_vault_name" {
  description = "1Password vault name containing the SSH key."
  type        = string
  default     = "Home-Ops"
}

variable "op_ssh_key_name" {
  description = "1Password SSH key name."
  type        = string
  default     = "Home-Ops SSH Key"
}
