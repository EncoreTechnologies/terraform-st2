# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

# Install StackStorm onto an Ubuntu 16.04 (Xenial) image 
data "aws_ami" "ubuntu1604" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create a security rule to allow SSH from the local host to the StackStorm instance
# This way we can remote-exec in and install StackStorm on the new instance
resource "aws_security_group" "stackstorm_allow_ssh_https" {
  name        = "stackstorm_allow_ssh_https"
  description = "Allow SSH and HTTPS inbound to the StackStorm test instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_ip_cidr}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.public_ip_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# StackStorm EC2 Instance
resource "aws_instance" "stackstorm" {
  ami           = "${data.aws_ami.ubuntu1604.id}"
  instance_type = "${var.aws_instance_type}"
  key_name      = "${var.aws_key_pair}"

  # allows SSH so we can remote-exec install below
  security_groups = ["${aws_security_group.stackstorm_allow_ssh_https.name}"]

  # install StackStorm
  provisioner "remote-exec" {
    inline = [
      "curl -sSL https://stackstorm.com/packages/install.sh | bash -s -- --user=${var.stackstorm_username} --password='${var.stackstorm_password}'"
    ]
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_private_key_pem)}"
    }
  }
}
