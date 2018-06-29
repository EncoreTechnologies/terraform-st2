# Configure the Google Provider
provider "google" {
  credentials = "${file(var.gcp_service_account_key_file)}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

# Firewall rule to allow SSH
resource "google_compute_firewall" "ssh" {
  name    = "stackstorm-firewall-ssh"
  network = "${var.vm_network}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["stackstorm-firewall-ssh"]
  source_ranges = ["${var.public_ip_cidr}"]
}

# Firewall rule to allow HTTPS
resource "google_compute_firewall" "https" {
  name    = "stackstorm-firewall-https"
  network = "${var.vm_network}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["stackstorm-firewall-https"]
  source_ranges = ["${var.public_ip_cidr}"]
}

# Firewall rule to allow ICMP ping
resource "google_compute_firewall" "icmp" {
  name    = "stackstorm-firewall-icmp"
  network = "${var.vm_network}"

  allow {
    protocol = "icmp"
  }

  target_tags   = ["stackstorm-firewall-icmp"]
  source_ranges = ["${var.public_ip_cidr}"]
}

# StackStorm instance
resource "google_compute_instance" "stackstorm" {
  name         = "${var.vm_name}"
  machine_type = "${var.vm_machine_type}"
  zone         = "${var.gcp_zone}"

  # associate our firewall rules to this instance
  tags = [
    "stackstorm-firewall-ssh",
    "stackstorm-firewall-https",
    "stackstorm-firewall-icmp"
  ]

  # OS image
  boot_disk {
    initialize_params {
      image = "${var.vm_image}"
    }
  }

  network_interface {
    network = "${var.vm_network}"

    access_config {
      // Ephemeral IP
    }
  }

  # Add our public SSH key onto the instance so we can SSH in
  metadata {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_public_key_path}")}"
  }

  # Associate our service account to this instance
  service_account {
    email = "${var.gcp_service_account_email}"
    scopes = ["compute-ro"]
  }

  # install StackStorm using SSH with our private key
  provisioner "remote-exec" {
    inline = [
      "curl -sSL https://stackstorm.com/packages/install.sh | sudo bash -s -- --user=${var.stackstorm_username} --password='${var.stackstorm_password}'"
    ]
    
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.ssh_private_key_path)}"
    }
  }
}
