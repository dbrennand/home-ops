# Terraform

Terraform is used to deploy infrastructure in my Homelab.

## Proxmox VE VM

Resources located in [`terraform/vm`](https://github.com/dbrennand/home-ops/tree/dev/terraform/vm) are used to deploy new VMs on Proxmox VE using the [bpg/proxmox](https://github.com/bpg/terraform-provider-proxmox) Terraform provider.

Default variables for VM deployment are located in [`terraform/vm/variables.tf`](https://github.com/dbrennand/home-ops/blob/dev/terraform/vm/variables.tf). These variables can be overridden in [`terraform/vm/terraform.tfvars`](https://github.com/dbrennand/home-ops/blob/dev/terraform/vm/terraform.tfvars). The VM resource is defined in [`terraform/vm/vm.tf`](https://github.com/dbrennand/home-ops/blob/dev/terraform/vm/vm.tf).

### Usage

1. Install Terraform:

    ```bash
    brew install terraform
    ```

2. Initialize Terraform providers:

    ```bash
    cd terraform/vm && terraform init
    ```

3. Populate the `terraform.tfvars` file with the required variables.

4. Plan the Terraform deployment:

    ```bash
    terraform plan
    ```

5. If everything looks good, apply the Terraform deployment:

    ```bash
    terraform apply
    ```
