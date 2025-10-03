# OpenTofu Module - Proxmox Cloud Init Configuration

Create a Proxmox Cloud Init Configuration file for a Virtual Machine.

## Usage

1. Initialise the module:

    ```bash
    tofu init
    ```

2. Call the module from a `.tf` file:

    ```hcl
    module "proxmox_cloud_init_config" {
        source = "./modules/proxmox_cloud_init_config"
        # Variables
        ...
    }
    ```

## License

See [LICENSE](LICENSE).
