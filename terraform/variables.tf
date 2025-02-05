variable "op_sa_token" {
  description = "1Password Service Account token."
  type        = string
  sensitive   = true
}

variable "op_proxmox_virtual_environment_vault_name" {
  description = "1Password vault name containing the Proxmox virtual environment item."
  type        = string
  default     = "Home-Ops"
}

variable "op_proxmox_virtual_environment_item_name" {
  description = "1Password virtual environment item name."
  type        = string
  default     = "proxmox01.net.dbren.uk"
}

variable "op_pihole_vault_name" {
  description = "1Password vault name containing the Proxmox virtual environment item."
  type        = string
  default     = "Home-Ops"
}

variable "op_pihole_item_name" {
  description = "1Password virtual environment item name."
  type        = string
  default     = "pihole01.net.dbren.uk"
}
