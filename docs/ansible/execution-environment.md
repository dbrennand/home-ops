# :simple-ansible: Execution Environment

An Ansible [Execution Environment (EE)](https://docs.ansible.com/ansible/latest/getting_started_ee/index.html) is used to run Ansible content against devices in my Homelab.

The EE is built using [`ansible-builder`](https://ansible.readthedocs.io/projects/builder/en/latest/).

## :simple-files: Execution Environment Files

Files relating to the Execution Environment are located in [`ansible/ee`](https://github.com/dbrennand/home-ops/tree/main/ansible/ee).

| File Path                                                                                                                      | Description                                                                                                     |
| ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------- |
| [`ansible/ee/execution-environment.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/ee/execution-environment.yml) | Configuration file used by `ansible-builder` to create the EE.                                                  |
| [`ansible/ee/requirements.txt`](https://github.com/dbrennand/home-ops/blob/main/ansible/ee/requirements.txt)                   | Extra Python dependencies to include in the EE.                                                                 |
| [`ansible/ee/requirements.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/ee/requirements.yml)                   | Ansible collection and roles to include in the EE.                                                              |
| [`ansible/ee/custom_entrypoint.sh`](https://github.com/dbrennand/home-ops/blob/main/ansible/ee/custom_entrypoint.sh)           | Entrypoint script used to configure specific environments variables for the 1Password CLI and SSH agent socket. |

## :simple-1password: Secrets

The 1Password CLI is [installed](https://github.com/dbrennand/home-ops/blob/main/ansible/ee/execution-environment.yml#L18) in the EE to retrieve secrets for devices and services.

## :simple-githubactions: Automated Build

A [GitHub Action](https://github.com/dbrennand/home-ops/blob/main/.github/workflows/build-ee.yml) is set up to automatically re-build the EE when changes are made to files in [`ansible/ee`](https://github.com/dbrennand/home-ops/tree/main/ansible/ee).

## Using the Execution Environment

### Ansible Navigator

[`ansible-navigator`](https://ansible.readthedocs.io/projects/navigator/) is used on my Macbook M1 Pro Max to run Ansible Content against devices in my Homelab. Under the hood `ansible-navigator` uses [`ansible-runner`](https://ansible.readthedocs.io/projects/runner/en/latest/) to interact with the container engine to launch the EE. I use [OrbStack](https://orbstack.dev/) which has a compatible [Docker engine](https://docs.orbstack.dev/docker/).

`ansible-navigator` is configured using the [`ansible-navigator.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/ansible-navigator.yml) file. I use [specific configuration](https://github.com/dbrennand/home-ops/blob/main/ansible/ansible-navigator.yml#L7) so that the EE can access the [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/) running on my Macbook to connect to devices. Furthermore, as mentioned above the EE has the 1Password CLI installed which is used by the [`community.general.onepassword`](https://docs.ansible.com/ansible/latest/collections/community/general/onepassword_lookup.html) lookup plugin to retrieve secrets from a 1Password vault.

### AWX

The EE is used by my AWX instance to run Ansible Content against devices in my Homelab. See [AWX](awx.md) for more information.
