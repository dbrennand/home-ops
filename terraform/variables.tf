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

variable "op_ssh_vault_name" {
  description = "1Password vault name containing the SSH key."
  type        = string
}

variable "op_ssh_key_name" {
  description = "1Password SSH key name."
  type        = string
}

variable "op_exit01_vault_name" {
  description = "1Password vault name containing the exit01 item."
  type        = string
  default     = "Home-Ops"
}

variable "op_exit01_item_name" {
  description = "1Password exit01 item name."
  type        = string
  default     = "exit01.net.dbren.uk"
}
