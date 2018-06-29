# Path to GCP Service Account Key file in JSON format
variable "gcp_service_account_key_file" {}

# GCP Service Account email addres (in the service account key file, it's the `client_email` property)
variable "gcp_service_account_email" {}

# Project name in GCP to provision the instance to (Service Account also belongs to this project)
variable "gcp_project" {}

# Region in GCP to provision this instance to
variable "gcp_region" {}

# Zone in GCP region to provision this instance to
variable "gcp_zone" {}

# Name of the GCE VM instance (must be unique)
variable "vm_name" {
  default = "stackstorm"
}

# Machine type of the GCP VM instance
# https://docs.stackstorm.com/install/system_requirements.html
# n1-standard-2 = 2 vCPU 7.5 GB RAM
variable "vm_machine_type" {
  default = "n1-standard-2"
}

# VM base image name
# For public images, the following are valid:
# - CentOS 6 = "centos-cloud/centos-6"
# - CentOS 7 = "centos-cloud/centos-7"
# - Ubuntu 14.04 = "ubuntu-os-cloud/ubuntu-1404-lts"
# - Ubuntu 16.04 = "ubuntu-os-cloud/ubuntu-1604-lts"
variable "vm_image" {
  default = "centos-cloud/centos-7"
}

# Name of the network to place the VM on
variable "vm_network" {
  default = "default"
}

# Public IP (CIDR notation) of the machine you're running terraform from (this limits the firewall rules so only you can login via ssh/https)
variable "public_ip_cidr" {}

# Path to your SSH private key
variable "ssh_private_key_path" {
  default = "~/.ssh/id_rsa"
}

# Path to your SSH public key
variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

# Username to use for SSH (note: this can NOT be 'root', GCP denies root SSH login)
variable "ssh_user" {}

# username for the StackStorm admin user
variable "stackstorm_username" {
  default = "st2admin"
}

# password for the StackStorm admin user
variable "stackstorm_password" {}
