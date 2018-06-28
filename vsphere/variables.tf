# vSphere login credentials
variable "vsphere_server" {}
variable "vsphere_username" {}
variable "vsphere_password" {}

# vSphere datacenter name
variable "vsphere_datacenter" {}

# vSphere cluster name
variable "vsphere_cluster" {}

# vSphere datastore name (must NOT be a datastore cluster)
variable "vsphere_datastore" {}

# # vSphere datastore cluster name (must NOT be a regular datastore)
# # uncomment this to use a datastore cluster isntead of plain old datastore
# variable "vsphere_datastore_cluster" {}

# vSphere network name (aka port group)
variable "vsphere_network" {}

# Name of the template in vSphere to clone.
# This must be on of the following OS's
# - CentOS 6
# - CentOS 7
# - Ubuntu 14.04
# - Ubuntu 16.04
variable "vsphere_template" {}

# hostname of the test VM (without the domain)
variable "vm_hostname" {
  default = "stackstorm"
}

# domain of the test VM
variable "vm_domain" {
  default = "test.internal"
}

# IP address of the test VM
variable "vm_ip_address" {}

# netmask of the test vm, in bits (ex: 24 for 255.255.255.0)
variable "vm_ip_netmask" {
  default = 24
}

# default gateway for the test VM
variable "vm_ip_gateway" {}

# list of DNS servers example: '["10.0.0.3", "10.0.0.4"]'
variable "vm_dns_server_list" {
  type = "list"
}

# Number of vCPU for the VM
variable "vm_num_cpu" {
  default = 2
}

# ammount of memory (in megabytes) to allocate on the VM
variable "vm_memory_mb" {
  default = 2048
}

# username to login to VM over SSH
variable "vm_username" {
  default = "root"
}

# password to login to VM over SSH
variable "vm_password" {}

# username for the StackStorm admin user
variable "stackstorm_username" {
  default = "st2admin"
}

# password for the StackStorm admin user
variable "stackstorm_password" {}
