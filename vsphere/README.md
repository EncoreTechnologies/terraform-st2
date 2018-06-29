# vSphere

This Terraform recipe provisions a new VM in vSphere by cloning an existing template.

**NOTE** The template must be one of the following OS types:
* CentOS/RHEL 6
* CentOS/RHEL 7
* Ubuntu 14.04
* Ubuntu 16.04


## Variables

To provision StackStorm in AWS you'll need to provide values for the following variables:

* `vsphere_server` - Hostname/IP of the vSphere server
* `vsphere_username` - Username to login to the vSphere server
* `vsphere_password` - Password to login to the vSphere server
* `vsphere_datacenter` - Name of a datacenter in vSphere
* `vsphere_cluster` - Name of a cluster in vSphere
* `vsphere_network` - Name of a network port group in vSphere
* `vsphere_datastore` - Name of a datastore in vSphere (must **NOT** be a datastore cluster)
* `vsphere_template` - Name of the source template to clone from (**MUST** be one of the supported OSes)

* `vm_hostname` - Hostname of the test VM (without the domain) [default = `"stackstorm"`]
* `vm_domain` - Domain of the test VM [default = `"test.internal"`]
* `vm_ip_address` - IP address of the test VM
* `vm_ip_netmask` - Netmask of the test vm, in bits (ex: 24 for 255.255.255.0) [default = `24`]
* `vm_ip_gateway` - Gateway of the test VM
* `vm_dns_server_list` - List of DNS servers example: `'["10.0.0.3", "10.0.0.4"]'`
* `vm_num_cpu` - Number of vCPU for the VM [default = `2`]
* `vm_memory_mb` - Ammount of memory (in megabytes) to allocate on the VM [default = `2048`]
* `vm_username` - Username to login to the VM over SSH [default = `root`]
* `vm_password` - Password to login to the VM over SSH
* `stackstorm_username` - Username for the StackStorm admin user [default = `st2admin`]
* `stackstorm_password` - Password for the StackStorm admin user

Reference: https://www.terraform.io/docs/providers/vsphere/r/virtual_machine.html

## Execution

### Setup Provider

``` shell
cd terraform-st2/vsphere

# download the vSphere provider
terraform init
```

### Initialize Variables

``` shell
export TF_VAR_vsphere_server="vsphere.domain.tld"
export TF_VAR_vsphere_username="username@domain.tld"
export TF_VAR_vsphere_password="Secret!"
export TF_VAR_vsphere_datacenter="dctr1"
export TF_VAR_vsphere_cluster="clstr1"
export TF_VAR_vsphere_datastore="ds-dev1-vol3"
export TF_VAR_vsphere_network="VLAN_1234_testing_sandbox"
export TF_VAR_vsphere_template="RHEL7_Template"

export TF_VAR_vm_hostname="stackstorm"
export TF_VAR_vm_domain="domain.tld"
export TF_VAR_vm_ip_address="10.1.2.33"
export TF_VAR_vm_ip_netmask="24"
export TF_VAR_vm_ip_gateway="10.1.2.1"
export TF_VAR_vm_dns_server_list='["10.0.0.3", "10.0.0.4"]'`
export TF_VAR_vm_password="VmsPassword"

export TF_VAR_stackstorm_password="SomePassword"
```

We choose to use Environment variables for our terraform variables.
There are several other ways variables can be passed in, including CLI, files, etc.
For more information on setting variables, or using one of these alternate
variable approaches please see the [Terraform variables documentation](https://www.terraform.io/intro/getting-started/variables.html).

### Provision

``` shell
terraform plan
terraform apply
```

### Login

Login to the VM via SSH:

``` shell
ssh stackstorm.domain.tld
```

Open up your web browser and goto: 

``` shell
https://stackstorm.domain.tld
```

You can login with the StackStorm credentials you set for the variables `stackstorm_admin` and `stackstorm_password`.

**Note** The default `stackstorm_username` is `st2admin`

