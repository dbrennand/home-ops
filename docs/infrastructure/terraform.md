# :simple-terraform: Terraform / OpenTofu

OpenTofu is used to deploy infrastructure in my Homelab.

Resources located in [`terraform`](https://github.com/dbrennand/home-ops/tree/dev/terraform/) are used to manage:

- Proxmox VMs.
- Pi-hole DNS records.

## Module

The OpenTofu [`proxmox_vm`](https://github.com/dbrennand/home-ops/tree/dev/terraform/modules/proxmox_vm) module is used to deploy VMs on Proxmox in a consistent manner from a VM template.

## Usage

1. Install OpenTofu:

    ```bash
    brew install opentofu
    ```

2. Populate the `.env` file with the required variables:

    ```bash
    cd terraform
    cp .env.example .env
    vim .env
    ```

3. Initialize OpenTofu providers and S3 backend:

    ```bash
    op run --env-file=./.env -- tofu init
    ```

4. Plan the deployment:

    ```bash
    op run --env-file=./.env -- tofu plan
    ```

5. If everything looks good, apply the deployment:

    ```bash
    op run --env-file=./.env -- tofu apply
    ```

### Destroying specific resources

To destroy specific resources, use the [`tofu destroy`](https://opentofu.org/docs/cli/commands/destroy/) command with the `-target` flag:

```bash
op run --env-file=./.env -- tofu destroy -target module.proxmox_vm_control01 -target module.proxmox_vm_worker01 -target module.proxmox_vm_worker02
```

### Removing state for manually destroyed resources

If resources are manually destroyed, the state file will need to be updated to reflect the changes to the infrastructure. To do this, use the [`tofu state rm`](https://opentofu.org/docs/v1.6/cli/commands/state/rm/) command:

```bash
op run --env-file=./.env -- tofu state rm 'module.proxmox_vm_worker02'
```
