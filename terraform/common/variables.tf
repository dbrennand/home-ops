variable "op_ssh_vault_name" {
  description = "1Password vault name containing the SSH key"
  type        = string
}

variable "op_ssh_key_name" {
  description = "1Password SSH key name"
  type        = string
}

variable "virtual_environment_endpoint" {
  description = "Proxmox VE API endpoint"
  type        = string
}

variable "virtual_environment_username" {
  description = "Proxmox VE Username"
  type        = string
  default     = "root@pam"
}

variable "virtual_environment_password" {
  description = "Proxmox VE Password"
  type        = string
  sensitive   = true
}

variable "virtual_environment_node" {
  description = "Name of the Proxmox VE node"
  type        = string
  default     = "proxmox01"
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "vm_description" {
  description = "Description of the VM"
  type        = string
  default     = "Created by Terraform on ${local.date}"
}

variable "vm_tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = ["common"]
}

variable "vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Amount of memory for the VM"
  type        = number
  default     = 2048
}

variable "vm_ip" {
  description = "IP address for the VM"
  type        = string
}

variable "vm_gateway" {
  description = "Gateway IP address for the VM"
  type        = string
  default     = "192.168.0.1"
}

variable "vm_username" {
  description = "Username for the VM"
  type        = string
}

variable "vm_password" {
  description = "Password for the VM"
  type        = string
  sensitive   = true
}

variable "virtual_environment_template_vm_id" {
  description = "ID of the Proxmox VE template VM used for cloning"
  type        = number
  default     = 9000
}

variable "virtual_environment_disk_datastore_id" {
  description = "ID of the Proxmox VE datastore used for the VM disk"
  type        = string
  default     = "local-lvm"
}
