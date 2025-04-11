#!/bin/bash
# License: MIT
# This script is used as an entrypoint for the Execution Environment container image
# to authenticate the op CLI using a service account.
# See: https://developer.1password.com/docs/service-accounts/use-with-1password-cli/
# The contents of the default ansible-builder entrypoint:
# https://github.com/ansible/ansible-builder/blob/devel/src/ansible_builder/_target_scripts/entrypoint
# are appended to this script.
# We do not directly pass the OP_SERVICE_ACCOUNT_TOKEN environment variable because
# then the terminal session on the host will only be authenticated as the service
# account. We pass a slightly different environment variable named "ONEPASSWORD_SERVICE_ACCOUNT_TOKEN"
# and then set this environment variable's value to OP_SERVICE_ACCOUNT_TOKEN.
export OP_SERVICE_ACCOUNT_TOKEN="${ONEPASSWORD_SERVICE_ACCOUNT_TOKEN}"
