terraform {
  required_version = ">= 1.6.2"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.80.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "2.1.2"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    http = {
      source = "hashicorp/http"
      version = "3.5.0"
    }
  }
  backend "s3" {
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_s3_checksum            = true
    encrypt                     = true
    key                         = "terraform.tfstate"
    region                      = "eu-central-003"
    bucket                      = "homeops"
    endpoints = {
      s3 = "s3.eu-central-003.backblazeb2.com"
    }
  }
}
