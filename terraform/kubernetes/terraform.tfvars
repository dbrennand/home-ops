# 1Password variables
op_sa_token                       = ""
op_virtual_environment_vault_name = ""
op_virtual_environment_item_name  = ""
op_ssh_vault_name                 = ""
op_ssh_key_name                   = ""

# K3s cluster nodes
nodes = [
  {
    name        = "control01"
    description = "K3s Control Node"
    ip          = ""
    memory      = 8192
    cores       = 4
    username    = ""
    password    = ""
  },
  {
    name        = "worker01"
    description = "K3s Worker Node 1"
    ip          = ""
    memory      = 4096
    cores       = 2
    username    = ""
    password    = ""
  },
  {
    name        = "worker02"
    description = "K3s Worker Node 2"
    ip          = ""
    memory      = 4096
    cores       = 2
    username    = ""
    password    = ""
  },
  {
    name        = "worker03"
    description = "K3s Worker Node 3"
    ip          = ""
    memory      = 4096
    cores       = 2
    username    = ""
    password    = ""
  }
]
