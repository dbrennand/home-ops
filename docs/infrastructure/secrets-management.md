# :simple-1password: Secrets Management

[1Password](https://1password.com/) is used for managing secrets for devices and services deployed in my Homelab.

## Integrations

1Password has various [developer](https://developer.1password.com/) integrations which I use. I also use open source community developed tooling too. These include:

- [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/)
- [1Password CLI (op)](https://developer.1password.com/docs/cli/get-started/)
- [1Password Service Accounts](https://developer.1password.com/docs/service-accounts/)
- [1Password Terraform Provider](https://search.opentofu.org/provider/1password/onepassword/latest)
- [`community.general.onepassword` Ansible Lookup Plugin](https://docs.ansible.com/ansible/latest/collections/community/general/onepassword_lookup.html)

The 1Password Service Accounts are used to authenticate these integrations and are restricted to only read from a specific vault.
