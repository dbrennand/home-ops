# Red Hat Enterprise Linux (RHEL) 9 Proxmox VM Template

## Prerequisites

* An active [Red Hat Developer subscription](https://developers.redhat.com/articles/faqs-no-cost-red-hat-enterprise-linux).

* Created an [Activation Key](https://console.redhat.com/insights/connector/activation-keys).

## Create the Guest Image

The guest image (`.qcow2`) will be created using the [Red Hat Image Builder](https://console.redhat.com/insights/image-builder).

1. Navigate to the [Red Hat Image Builder](https://console.redhat.com/insights/image-builder).
2. Click **Create Image**.
3. Under *Image output* - choose **Red Hat Enterprise Linux (RHEL) 9** as the *Release*.
4. Under *Image output* - choose **Virtualization - Guest image (.qcow2)** as the target environment.
5. Under *Register systems using this image* - select your activation key under *Activation key to use for this image*.
6. Under *Additional Red Hat packages* - search available packages for `cloud-init` and `qemu-guest-agent` and add them to the list of chosen packages.
7. Under *Details* - enter a name for the image.
8. Click **Create image**.

It should take a few minutes for the image to be created. Once created, download it to your local machine.

## Loading the Guest Image into Proxmox

Use the [create-vm-template.yml] Ansible playbook to load the guest image into Proxmox. The playbook will create a new VM template from the guest image.
