terraform {
  required_version = ">= 1.6.2"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.63.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "2.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.2.0"
    }
  }
  # Unable to pass variables to backend config
  # Tracked in: https://github.com/hashicorp/terraform/issues/13022
  # OpenTofu issue: https://github.com/opentofu/opentofu/issues/1042
  backend "s3" {
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_s3_checksum            = true
    encrypt                     = true
    key                         = "terraform.tfstate"
    region                      = "us-west-000"
    bucket                      = "homeops"
    endpoints = {
      s3 = "https://s3.us-west-000.backblazeb2.com"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external
# 1Password Terraform provider does not support retrieving SSH keys yet :(
# https://github.com/1Password/terraform-provider-onepassword/issues/74
data "external" "op_ssh_key" {
  program = ["./hack/op-ssh.sh"]
  query = {
    vault = var.op_ssh_vault_name
    title = var.op_ssh_key_name
  }
}
