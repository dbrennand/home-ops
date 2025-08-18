# :simple-opentofu: OpenTofu

[OpenTofu](https://opentofu.org/) (a fork of Terraform) is used to deploy infrastructure in my Homelab. Resources located in [`terraform`](https://github.com/dbrennand/home-ops/tree/main/terraform/) are used to deploy VMs on my Proxmox VE cluster.

## Custom Module(s)

My Home-Ops project contains two OpenTofu modules I've created, but as of writing I'm only using the [`proxmox_vm`](https://github.com/dbrennand/home-ops/tree/main/terraform/modules/proxmox_vm) module. This module deploys VMs with [AlmaLinux](https://almalinux.org/) 9 as the operating system, and creates a cloud-init configuration so each VM is ready for use when booted.

## OpenTofu State

The [OpenTofu state](https://opentofu.org/docs/language/state/) is stored in a Backblaze S3 bucket.

## :lock: Secrets

The [1Password Terraform provider](https://search.opentofu.org/provider/1password/onepassword/latest) is used to retrieve credentials for Proxmox and an SSH key used during VM creation by the [`proxmox_vm`](https://github.com/dbrennand/home-ops/tree/main/terraform/modules/proxmox_vm) module.

## Usage

1. Install OpenTofu:

    ```bash
    brew install opentofu
    ```

2. Initialize OpenTofu providers and the S3 backend:

    ```bash
    cd terraform
    op run --env-file=./.env -- tofu init
    ```

3. Plan the deployment:

    ```bash
    op run --env-file=./.env -- tofu plan
    ```

4. If everything looks good, apply the deployment:

    ```bash
    op run --env-file=./.env -- tofu apply
    ```

## Destroying Specific Resources

To destroy specific resources, use the [`tofu destroy`](https://opentofu.org/docs/cli/commands/destroy/) command with the `-target` flag:

```bash
op run --env-file=./.env -- tofu destroy -target module.proxmox_vm_control01 -target module.proxmox_vm_worker01 -target module.proxmox_vm_worker02
```

## Removing State for Manually Destroyed Resources

If resources are manually destroyed, the state file will need to be updated to reflect the changes to the infrastructure. To do this, use the [`tofu state rm`](https://opentofu.org/docs/v1.6/cli/commands/state/rm/) command:

```bash
op run --env-file=./.env -- tofu state rm 'module.proxmox_vm_worker02'
```
