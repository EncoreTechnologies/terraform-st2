# access key for your AWS IAM user account
variable "aws_access_key" {}

# secret key for your AWS IAM user account
variable "aws_secret_key" {}

# name of the AWS key pair, used to create your instance password
variable "aws_key_pair" {}

# path to your AWS private key file (.pem) on your local disk
variable "aws_private_key_pem" {}

# AWS region where VM should be deployed
variable "aws_region" {
  default = "us-east-2"
}

# Type of AWS instances to provision
# https://docs.stackstorm.com/install/system_requirements.html
# t2.medium is minimum recommended setup for testing
variable "aws_instance_type" {
  default = "t2.medium"
}

# Public IP (CIDR notation) of the machine you're running terraform from (this limits the firewall rules so only you can login via ssh/https)
variable "public_ip_cidr" {}

# username for the StackStorm admin user
variable "stackstorm_username" {
  default = "st2admin"
}

# password for the StackStorm admin user
variable "stackstorm_password" {}
