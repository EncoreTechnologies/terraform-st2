# Google Cloud Platform (GCP)

This Terraform recipe provisions a new GCP Compute Engine instance for a test instance of StackStorm.

## Variables

To provision StackStorm you'll need to provide values for the following variables:

* `gcp_service_account_key_file` - Path to GCP Service Account Key file in JSON format [reference: https://cloud.google.com/video-intelligence/docs/common/auth]
* `gcp_service_account_email` - GCP Service Account email addres (in the service account key file, it's the `client_email` property)
* `gcp_project` - Project ID in GCP to provision the instance to (Service Account also belongs to this project)
* `gcp_region` - Region in GCP to provision this instance to [reference: https://cloud.google.com/compute/docs/regions-zones/]
* `gcp_zone` - Zone in GCP region to provision this instance to (see reference in `gcp_region`)
* `vm_name` - Name of the GCE VM instance (must be unique) [default = `stackstorm`]
* `vm_machine_type` - Machine type of the GCP VM instance [default = `n1-standard-2`] [reference: https://cloud.google.com/compute/docs/machine-types]
* `vm_image` - Name of the VM image to use, format of `<image-project>/<image-family>` [default = `centos-cloud/centos-7`] [reference: https://cloud.google.com/compute/docs/images]
 * CentOS 6 = `centos-cloud/centos-6`
 * CentOS 7 = `centos-cloud/centos-7`
 * Ubuntu 14.04 = `ubuntu-os-cloud/ubuntu-1404-lts`
 * Ubuntu 16.04 = `ubuntu-os-cloud/ubuntu-1604-lts`
* `vm_network` - Name of the network to place the VM on. [default = `default`] 
* `public_ip_cidr` - Public IP (CIDR notation) of the machine you're running terraform from (this limits the firewall rules so only you can login via ssh/https)
* `ssh_private_key_path` -  Path to your SSH private key [default = `~/.ssh/id_rsa`]
* `ssh_public_key_path` -  Path to your SSH public key [default = `~/.ssh/id_rsa.pub`]
* `ssh_user` - Username to use for SSH (note: this can NOT be 'root', GCP denies root SSH login)
* `stackstorm_username` - Username for the StackStorm admin user [default = `st2admin`]
* `stackstorm_password` - Password for the StackStorm admin user.

For more information about these variables see: https://www.terraform.io/docs/providers/google/index.html

## Execution

### Setup Provider

``` shell
cd terraform-st2/gcp

# download the GCP provider (Google)
terraform init

```

### Initialize Variables

``` shell
export TF_VAR_gcp_service_account_key_file="~/path/to/svc-account-1234.json"
# use 'jq' to automatically get the 'client_email' property from the exiting 
# config file, otherwise you'll have to extract it yourself
export TF_VAR_gcp_service_account_email=$(cat $TF_VAR_gcp_service_account_key_file | jq -r '.client_email')
export TF_VAR_gcp_project="stackstorm-terraform"
export TF_VAR_gcp_region="us-central1"
export TF_VAR_gcp_zone="us-central1-a"

export TF_VAR_public_ip_cidr="`curl http://ipecho.net/plain`/32"
export TF_VAR_ssh_user=$USER

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

The public IP address will be available in the Google Comput Engine Instances console.

### Login

Login to the VM via SSH:

``` shell
# if you used your own username and public SSH key
ssh 1.2.3.4

# if you specified a speicla username or ssh key
ssh -i $TF_VAR_ssh_private_key_path $TF_VAR_ssh_user@1.2.3.4
```

Open up your web browser and goto: 

``` shell
https://1.2.3.4
```

You can login with the StackStorm credentials you set for the variables `stackstorm_admin` and `stackstorm_password`.

**Note** The default `stackstorm_username` is `st2admin`

