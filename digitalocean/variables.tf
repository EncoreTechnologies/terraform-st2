variable "do_droplet_type" {
	default = "s-2vcpu-4gb"
}

variable "do_existing_ssh_public_key_name" {
  type    = string
  default = null
}

variable "do_vpc_name" {
  type    = string
  default = null
}

variable "do_new_ssh_public_key_name" {
  type    = string
  default = null
}

variable "do_new_ssh_public_key_file" {
  type    = string
  default = null
}

variable "do_project_name" {
  default = "terraformed-st2"
}

variable "do_region" {
	default = "sfo3"
}

variable "do_token" {}

variable "do_ssh_private_key_file" {}

variable "public_ip_cidr" {}

variable "do_stackstorm_droplet_count" {
  default = 1
}

variable "stackstorm_username" {
  default = "st2admin"
}

variable "stackstorm_password" {}
