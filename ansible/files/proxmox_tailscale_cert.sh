#!/bin/bash
# Used on Proxmox node(s) to generate a certificate for the node's Tailscale FQDN
# This allows for the Proxmox Web GUI to be accessed via the Tailscale FQDN
# Requires jq and tailscale to be installed
# Checks every 60 days if the certificate needs to be renewed

# File where the last run date is stored
LAST_RUN_FILE="${HOME}/proxmox_tailscale_cert.last_run"

# Read the last run date from the file
if [[ -f "${LAST_RUN_FILE}" ]]; then
    last_run=$(cat "${LAST_RUN_FILE}")
else
    last_run=$(date -d "60 days ago" +%F)
fi

# Calculate the next run date (60 days after the last run)
next_run=$(date -d "${last_run} + 60 days" +%F)
today=$(date +%F)

# Run the task if today is the next run date
if [[ "${today}" == "${next_run}" ]]; then
    # Snippet below taken from: https://tailscale.com/kb/1133/proxmox#enable-https-access-to-the-proxmox-web-ui
    NAME="$(tailscale status --json | jq '.Self.DNSName | .[:-1]' -r)"
    tailscale cert "${NAME}"
    pvenode cert set "${NAME}.crt" "${NAME}.key" --force --restart
    # Update the last run date
    echo "${today}" > "${LAST_RUN_FILE}"
fi
