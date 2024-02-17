# 1Password variables
op_sa_token                       = ""
op_virtual_environment_vault_name = ""
op_virtual_environment_item_name  = ""
op_ssh_vault_name                 = ""
op_ssh_key_name                   = ""

# K3s control nodes
control_nodes = [
  {
    name        = "control01"
    description = "K3s Control Node 1"
    tags        = ["k3s", "kubernetes", "control"]
    ip          = ""
    memory      = 8192
    cores       = 4
    username    = ""
    password    = ""
  }
]

# K3s worker nodes
worker_nodes = [
  {
    name        = "worker01"
    description = "K3s Worker Node 1"
    tags        = ["k3s", "kubernetes", "worker"]
    ip          = ""
    memory      = 4096
    cores       = 2
    username    = ""
    password    = ""
  },
  {
    name        = "worker02"
    description = "K3s Worker Node 2"
    tags        = ["k3s", "kubernetes", "worker"]
    ip          = ""
    memory      = 4096
    cores       = 2
    username    = ""
    password    = ""
  },
  {
    name        = "worker03"
    description = "K3s Worker Node 3"
    tags        = ["k3s", "kubernetes", "worker"]
    ip          = ""
    memory      = 4096
    cores       = 2
    username    = ""
    password    = ""
  }
]
