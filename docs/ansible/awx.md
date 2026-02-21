# :simple-ansible: AWX

[AWX](https://github.com/ansible/awx) is used in my Homelab to run Ansible content against devices.

AWX is deployed via the [AWX Operator](https://github.com/ansible/awx-operator) on Kubernetes. I'm running version `2.19.1` of the operator.

I have a single node [K3s](https://k3s.io/) VM on my Proxmox VE node which I deployed using [OpenTofu](../infrastructure/opentofu.md). The K3s deployment is done via an [Ansible Playbook](https://github.com/dbrennand/home-ops/blob/main/ansible/playbooks/playbook-k3s.yml).

The [awx-on-k3s](https://github.com/kurokobo/awx-on-k3s) project is used to deploy the AWX Operator and AWX Custom Resource Definition (CRD) on K3s . I use an [Ansible playbook](https://github.com/dbrennand/home-ops/blob/main/ansible/playbooks/playbook-awx-deploy.yml) to prepare the K3s node for AWX deployment.

## Deployment

1. Run the [`playbook-awx-deploy.yml`](https://github.com/dbrennand/home-ops/blob/main/ansible/playbooks/playbook-awx-deploy.yml) Ansible playbook:

    ```bash
    ansible-playbook playbooks/playbook-awx-deploy.yml
    ```

2. Deploy AWX:

    ```
    ansible -b k3s01.net.dbren.uk -m command -a 'kubectl apply -k awx-on-k3s/base/'
    ```

## Configuration

An [Ansible playbook](https://github.com/dbrennand/home-ops/blob/main/ansible/playbooks/playbook-awx.yml) is used to configure AWX with the [Execution Environment](execution-environment.md), credentials, project, inventories and Discord notification template.
