resource "digitalocean_firewall" "stackstorm_allow_ssh_https" {
  name    = "stackstorm-allow-ssh-https"

  droplet_ids = digitalocean_droplet.st2[*].id

  inbound_rule {
    protocol          = "tcp"
    port_range        = "22"
    source_addresses  = [var.public_ip_cidr]
  }

  inbound_rule {
    protocol          = "tcp"
    port_range        = "443"
    source_addresses  = [var.public_ip_cidr]
  }

  outbound_rule {
    protocol          = "tcp"
    port_range        = "1-65535"
  }

  outbound_rule {
    protocol          = "udp"
    port_range        = "1-65535"
  }

  outbound_rule {
    protocol          = "icmp"
  }
}

data "digitalocean_vpc" "terraform_st2" {
  count = var.do_vpc_name != null ? 1 : 0
  name  = var.do_vpc_name
}

locals {
  do_st2_vpc_id = var.do_vpc_name == null ? null : data.digitalocean_vpc.terraform_st2[0].id
}
