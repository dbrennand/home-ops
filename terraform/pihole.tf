# https://github.com/ryanwholey/terraform-provider-pihole
provider "pihole" {
  url      = data.onepassword_item.pihole.url
  password = data.onepassword_item.pihole.password
}

# Pi-hole DNS A records

# https://registry.terraform.io/providers/ryanwholey/pihole/latest/docs/resources/dns_record
resource "pihole_dns_record" "proxmox02" {
  domain = "proxmox02.net.dbren.uk"
  ip     = "192.168.0.3"
}

resource "pihole_dns_record" "proxmox01" {
  domain = "proxmox01.net.dbren.uk"
  ip     = "192.168.0.4"
}

resource "pihole_dns_record" "pihole02" {
  domain = "pihole02.net.dbren.uk"
  ip     = "192.168.0.5"
}

resource "pihole_dns_record" "backup01" {
  domain = "backup01.net.dbren.uk"
  ip     = "192.168.0.6"
}

resource "pihole_dns_record" "exit01" {
  domain = "exit01.net.dbren.uk"
  ip     = "192.168.0.7"
}

resource "pihole_dns_record" "exit02" {
  domain = "exit02.net.dbren.uk"
  ip     = "192.168.0.8"
}

resource "pihole_dns_record" "media01" {
  domain = "media01.net.dbren.uk"
  ip     = "192.168.0.9"
}
