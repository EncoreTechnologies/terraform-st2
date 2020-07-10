data "digitalocean_ssh_key" "st2_root" {
  count = var.do_existing_ssh_public_key_name != null ? 1 : 0
  name  = var.do_existing_ssh_public_key_name
}

resource "digitalocean_ssh_key" "st2_root" {
  count      = var.do_new_ssh_public_key_name != null ? 1 : 0
  name       = var.do_new_ssh_public_key_name
  public_key = file(var.do_new_ssh_public_key_file)
}

locals {
  ssh_key_fingerprint = flatten([data.digitalocean_ssh_key.st2_root[*].fingerprint, digitalocean_ssh_key.st2_root[*].fingerprint])
}