variable "op_sa_token" {
  description = "1Password Service Account token"
  type        = string
  sensitive   = true
}

variable "op_virtual_environment_vault_name" {
  description = "1Password vault name containing the virtual environment item"
  type        = string
}

variable "op_virtual_environment_item_name" {
  description = "1Password virtual environment item name"
  type        = string
}

variable "op_ssh_vault_name" {
  description = "1Password vault name containing the SSH key"
  type        = string
}

variable "op_ssh_key_name" {
  description = "1Password SSH key name"
  type        = string
}

variable "virtual_environment_username" {
  description = "Proxmox VE Username"
  type        = string
  default     = "root@pam"
}

variable "virtual_environment_node" {
  description = "Name of the Proxmox VE node"
  type        = string
  default     = "proxmox01"
}

variable "virtual_environment_template_vm_id" {
  description = "ID of the Proxmox VE template VM used for cloning"
  type        = number
  default     = 9000
}

variable "virtual_environment_os_disk_datastore_id" {
  description = "ID of the Proxmox VE datastore used for the OS disk"
  type        = string
  default     = "ssd-samsung"
}

variable "virtual_environment_data_disk_datastore_id" {
  description = "ID of the Proxmox VE datastore used for the data disk"
  type        = string
  default     = "ssd-crucial"
}

variable "nodes_gateway" {
  description = "Gateway IP address for the K3s nodes"
  type        = string
  default     = "192.168.0.1"
}

variable "control_nodes" {
  description = "K3s control nodes"
  type = list(object({
    name        = string
    description = string
    tags        = list(string)
    ip          = string
    memory      = number
    cores       = number
    username    = string
    password    = string
  }))
  default = []
}

variable "worker_nodes" {
  description = "K3s worker nodes"
  type = list(object({
    name        = string
    description = string
    tags        = list(string)
    ip          = string
    memory      = number
    cores       = number
    username    = string
    password    = string
  }))
  default = []
}
