#!/bin/bash
# Author: Daniel Brennand
# License: MIT
# This script acts as an executable Ansible Vault password file to encrypt and decrypt
# Ansible vault variables using a vault password stored in 1Password
# Requirements:
# - op CLI
# - jq
set -e
VAULT_ID="Home-Ops"
VAULT_ANSIBLE_NAME="Ansible Vault"
op item get --vault="${VAULT_ID}" "${VAULT_ANSIBLE_NAME}" --format json | jq '.fields[] | select(.id == "password") | .value' | tr -d '"'
