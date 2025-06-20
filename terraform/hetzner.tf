# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs
provider "hcloud" {}

# Get public IP address to restrict SSH access on the firewall
data "http" "public_ip" {
  url = "https://api.ipify.org"
}

resource "hcloud_firewall" "home_ops" {
  name = "Home-Ops"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["${chomp(data.http.public_ip.response_body)}/32"]
  }
  # https://tailscale.com/kb/1150/cloud-hetzner#step-2-allow-udp-port-41641
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "41641"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "home_ops" {
  name         = "Home-Ops"
  image        = "alma-9"
  server_type  = "cax11"
  location     = "hel1"
  user_data    = <<EOF
#cloud-config
users:
  - name: daniel
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ${trimspace(data.onepassword_item.ssh_key.public_key)}
ssh_pwauth: false
package_update: true
package_upgrade: true
packages:
  - openssh-server
runcmd:
  - systemctl enable --now sshd
  - timedatectl set-timezone Europe/London
EOF
  firewall_ids = [hcloud_firewall.home_ops.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  labels = {
    "type" : "Home-Ops"
  }
}
