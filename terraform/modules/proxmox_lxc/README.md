# OpenTofu Module - Proxmox LXC (Deprecated)

This module creates a Proxmox LXC based on the provided parameters.

## Usage

1. Initialise the module:

    ```bash
    tofu init
    ```

2. Call the module from a `.tf` file:

    ```hcl
    module "proxmox_lxc_hostname" {
        source = "./modules/proxmox_lxc"
        # Variables
        ...
    }
    ```

## License

See [LICENSE](LICENSE).
