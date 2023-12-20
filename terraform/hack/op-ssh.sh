#!/bin/bash
# Author: Daniel Brennand
# License: MIT
# This script uses the 1Password CLI to retrieve a SSH public key from a 1Password vault
# Requirements:
# - op CLI
# - jq
# https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external
set -e
eval "$(jq -r '@sh "VAULT=\(.vault) TITLE=\(.title)"')"
SSH_PUBLIC_KEY=$(op item get "${TITLE}" --fields "public key" --vault "${VAULT}")
jq -n --arg ssh_public_key "$SSH_PUBLIC_KEY" '{"ssh_public_key":$ssh_public_key}'
