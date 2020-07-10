resource "digitalocean_droplet" "st2" {
  count               = var.do_stackstorm_droplet_count
  image               = "ubuntu-18-04-x64"
  name                = "stackstorm-terraformed-${count.index}"
  region              = var.do_region
  size                = var.do_droplet_type
  ssh_keys            = local.ssh_key_fingerprint
  vpc_uuid            = local.do_st2_vpc_id

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.do_ssh_private_key_file)
    # we choose a high timeout to give the droplet some time to become ready
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt update",
      "sudo apt -y install curl",
      "curl -sSL https://stackstorm.com/packages/install.sh | bash -s -- --user=${var.stackstorm_username} --password='${var.stackstorm_password}'"
    ]
  }
}
