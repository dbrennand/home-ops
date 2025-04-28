# :simple-ansible: AWX

[AWX](https://github.com/ansible/awx) is used in my Homelab to run Ansible content against devices.

## Deployment

AWX is deployed via the [AWX Operator](https://github.com/ansible/awx-operator) on Kubernetes. I'm running version `2.19.1` of the operator.

I have a single node [K3s](https://k3s.io/) VM on my Proxmox VE cluster which I deployed using [OpenTofu](../infrastructure/opentofu.md). The K3s deployment is done via an [Ansible Playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/playbook-k3s-deploy.yml).

The [awx-on-k3s](https://github.com/kurokobo/awx-on-k3s) project is used to deploy the AWX Operator and AWX Custom Resource Definition (CRD) on the K3s cluster. I use an [Ansible playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/playbook-awx-deploy.yml) to prepare the K3s node for the AWX deployment.

Next, I perform the following steps to deploy AWX:

1. SSH to the K3s node:

    ```bash
    ssh daniel@k3s01.net.dbren.uk
    ```

2. Deploy the AWX Operator:

    ```bash
    cd awx-on-k3s && kubectl apply -k operator
    ```

3. Configure the ingress in `base/awx.yml` to use the `ClusterIssuer` for Cloudflare:

    ```yaml
    ---
    apiVersion: awx.ansible.com/v1beta1
    kind: AWX
    metadata:
      name: awx
    spec:
      # ...
      ingress_type: ingress
      ingress_hosts:
        - hostname: awx.net.dbren.uk
          tls_secret: awx-secret-tls
      ingress_annotations: |
        cert-manager.io/cluster-issuer: letsencrypt-production
    ```

3. Configure the PostgreSQL and AWX admin credentials in `base/kustomization.yaml`:

    ```yaml
    ---
    apiVersion: kustomize.config.k8s.io/v1beta1
    kind: Kustomization
    namespace: awx

    generatorOptions:
      disableNameSuffixHash: true

    secretGenerator:
      - name: awx-postgres-configuration
        type: Opaque
        literals:
          - host=awx-postgres-15
          - port=5432
          - database=awx
          - username=awx
          - password=<Password>
          - type=managed

      - name: awx-admin-password
        type: Opaque
        literals:
          - password=<Password>
    ```

4. Deploy the AWX CRD:

    ```bash
    kubectl apply -k base
    ```

## Configuration

An [Ansible playbook](https://github.com/dbrennand/home-ops/blob/dev/ansible/playbooks/playbook-awx.yml) is used to configure AWX with the [Execution Environment](execution-environment.md), credentials, project and inventories.
