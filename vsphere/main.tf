# Configure the vSphere provider
provider "vsphere" {
  user           = "${var.vsphere_username}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# # uncomment this to use a datastore cluster instead of a plain old datastore
# data "vsphere_datastore_cluster" "datastore_cluster" {
#   name          = "dev01-norepl4k-cluster-pur01"
#   datacenter_id = "${data.vsphere_datacenter.dc.id}"
# }

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_cluster}/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "stackstorm" {
  name                 = "${format("%s.%s", var.vm_hostname, var.vm_domain)}"
  resource_pool_id     = "${data.vsphere_resource_pool.pool.id}"
  # comment this out to use a datastore cluster
  datastore_id         = "${data.vsphere_datastore.datastore.id}"
  # # uncomment this to use a datastore cluster instead of a plain old datastore
  # datastore_cluster_id = "${data.vsphere_datastore_cluster.datastore_cluster.id}"

  num_cpus = "${var.vm_num_cpu}"
  memory   = "${var.vm_memory_mb}"

  guest_id  = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  # NIC definition, same as the template (hardware info)
  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # Disk information, same as the template (hardware info)
  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  # Clone from a template
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    # Perform customization after the clone
    customize {
      linux_options {
        host_name = "${var.vm_hostname}"
        domain    = "${var.vm_domain}"
      }

      network_interface {
        ipv4_address = "${var.vm_ip_address}"
        ipv4_netmask = "${var.vm_ip_netmask}"
      }

      ipv4_gateway = "${var.vm_ip_gateway}"
      dns_server_list = "${var.vm_dns_server_list}"
    }
  }

  # install StackStorm
  provisioner "remote-exec" {
    inline = [
      # # uncomment the following if you're on a RHEL host
      # "yum -y install http://<satellite_server>/pub/katello-ca-consumer-latest.noarch.rpm",
      # "subscription-manager register --org='Encore_Managed_Services' --activationkey='RHEL_7_DEV'",
      # "subscription-manager attach --auto",
      "curl -sSL https://stackstorm.com/packages/install.sh | bash -s -- --user=${var.stackstorm_username} --password='${var.stackstorm_password}'"
    ]

    # how terraform connects to the VM after it's up in order to install StackStorm
    connection {
      type     = "ssh"
      user     = "${var.vm_username}"
      password = "${var.vm_password}"
    }
  }
}
