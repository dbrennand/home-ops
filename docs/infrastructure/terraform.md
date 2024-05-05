# Terraform / OpenTofu

OpenTofu is used to deploy infrastructure in my Homelab.

Resources located in [`terraform`](https://github.com/dbrennand/home-ops/tree/dev/terraform/) are used to manage:

- Proxmox VMs
- Pi-hole DNS records

## Module

The OpenTofu [`proxmox_vm`](https://github.com/dbrennand/home-ops/tree/dev/terraform/modules/proxmox_vm) module is used to deploy VMs on Proxmox in a consistent manner from a VM template.

## Usage

1. Install OpenTofu:

    ```bash
    brew install opentofu
    ```

2. Initialize OpenTofu providers and S3 backend:

    ```bash
    cd terraform && op run --env-file=./.env -- tofu init
    ```

3. Populate the `.env` file with the required variables.

4. Plan the deployment:

    ```bash
    op run --env-file=./.env -- tofu plan
    ```

5. If everything looks good, apply the deployment:

    ```bash
    op run --env-file=./.env -- tofu apply
    ```

### Destroying specific resources

To destroy specific resources, use the `tofu destroy` command with the `-target` flag:

```bash
op run --env-file=./.env -- tofu destroy -target module.proxmox_vm_control01 -target module.proxmox_vm_worker01 -target module.proxmox_vm_worker02
```
