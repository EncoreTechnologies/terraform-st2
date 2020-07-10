# DigitalOcean (DO)

This Terraform recipe provisions new DigitalOcean droplets and optional a project, VPC and new SSH key to test StackStorm.

## Variables

### Mandatory

To provision StackStorm in DO you'll need to provide values for the following variables.

#### SSH configuration

Either a new or an existing key pair must be provided. Note that Terraform does not support passphrases on private keys. This means that `do_ssh_private_key_file` **must not** be protected with a passphrase.

If the public SSH key is already known to DO:
* `do_existing_ssh_public_key_name` - Name of an already existing SSH public key
* `do_ssh_private_key_file` - This key is used by Terraform to connect to the droplet and install st2

If a new key pair should be used:
* `do_new_ssh_public_key_name` - Name of the new SSH public key file (this name will be shown in the DO UI)
* `do_new_ssh_public_key_file` - Location of the new SSH public key file
* `do_ssh_private_key_file` - This key is used by Terraform to connect to the droplet and install st2

#### Authentication & Authorization

* `do_token` - DO personal access token to access the API and provision the resources
* `public_ip_cidr` - Public IP (CIDR notation) of the machine you're running terraform from (this limits the firewall rules so only you can login via ssh/https)
* `stackstorm_username` - Username for the StackStorm admin user [default = `st2admin`]
* `stackstorm_password` - Password for the StackStorm admin user.

For more information about these variables see: https://www.terraform.io/docs/providers/do/index.html

For information on how to create a DO personal access token: https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/

### Optional

Additional optional variables can be provided:
* `do_droplet_type` - Droplet type to be used. Default: s-2vcpu-4gb
* `do_project_name` - Name of the DO Project. Default: terraformed-st2
* `do_region` - DO region hosting the infrastructure. Default: sfo3
* `do_stackstorm_droplet_count` - Number of droplets to be provisioned. All droplets will run all services and will be completely independent from each other. This does **not** offer any kind of clustering or high-availability.

## Execution

### Setup Provider

``` shell
cd terraform-st2/digitalocean

# download the DO provider
terraform init

```

### Initialize Variables

``` shell
export TF_VAR_do_existing_ssh_public_key_name='do_terraform'
export TF_VAR_do_token='xxx'
export TF_VAR_do_ssh_private_key_file='/~/.ssh/do_terraform'
export TF_VAR_public_ip_cidr="$(curl -s http://ipecho.net/plain)/32"
export TF_VAR_stackstorm_password="yyy"
```

Add optional variables as per your needs.

We choose to use Environment variables for our terraform variables.
There are several other ways variables can be passed in, including CLI, files, etc.
For more information on setting variables, or using one of these alternate
variable approaches please see the [Terraform variables documentation](https://www.terraform.io/intro/getting-started/variables.html).

### Provision

``` shell
terraform plan
terraform apply
```

The internal hostname and IP address of the created droplets will be shown at the end of the Terraform run and are also available in the DO console.

### Login

Login to the VM via SSH:

``` shell
ssh -i "$TF_VARS_do_private_key_file" root@droplet-ip
```

Open up your web browser and goto: 

``` shell
https://<ip-of-the-droplet>
```

You can login with the StackStorm credentials you set for the variables `stackstorm_admin` and `stackstorm_password`.

**Note** The default `stackstorm_username` is `st2admin`

