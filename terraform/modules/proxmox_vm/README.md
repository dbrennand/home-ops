# OpenTofu Module - Proxmox Virtual Machine

This module creates a Proxmox Virtual Machine (VM) based on the provided parameters.

## Usage

1. Initialise the module:

    ```bash
    tofu init
    ```

2. Call the module from a `.tf` file:

    ```hcl
    module "proxmox_vm_hostname" {
        source = "./modules/proxmox_vm"
        # Variables
        ...
    }
    ```

## License

See [LICENSE](LICENSE).
