# AWS

This Terraform recipe provisions a new EC2 instance and Security Group for a test instance of StackStorm.

## Variables

To provision StackStorm in AWS you'll need to provide values for the following variables:

* `aws_access_key` - AWS access key for your IAM user.
* `aws_secret_key` - AWS secret key for your IAM user.
* `aws_key_pair` - Name of the key pair that will be used to generate the instance password.
* `aws_private_key_pem` - Path to your AWS private key file (.pem) on your local disk
* `aws_region` - The region to provision the VM in (default=`us-east-2`).
* `aws_instance_type` - Type of AWS instances to provision (default=`t2.medium`).
* `public_ip` - Public IP of the machine you're running terraform from
* `stackstorm_username` - Username for the StackStorm admin user (default=`st2admin`).
* `stackstorm_password` - Password for the StackStorm admin user.

Reference: https://www.terraform.io/docs/providers/aws/index.html

## Execution

Run the setup phase, then choose one of the provisioning options

### Setup Provider

``` shell
cd terraform-st2/aws

# download the AWS provider
terraform init

```

### Initialize Variables

``` shell
export TF_VAR_aws_access_key='xxx'
export TF_VAR_aws_secret_key='yyy'
export TF_VAR_aws_region='us-east-2'
export TF_VAR_aws_key_pair='DaveSmith'
export TF_VAR_aws_private_key_pem='~/.aws/DaveSmith.pem'
export TF_VAR_public_ip="`curl http://ipecho.net/plain`/32"
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

The public hostname and IP address will be available in the AWS EC2 Instances console.

### Login

Login to the VM via SSH:

``` shell
ssh -i "$TF_VARS_aws_private_key_pem" ubuntu@ec2-x-x-x-x.us-east-y.compute.amazonaws.com
```

Open up your web browser and goto: 

``` shell
https://ec2-x-x-x-x.us-east-y.compute.amazonaws.com
```

You can login with the StackStorm credentials you set for the variables `stackstorm_admin` and `stackstorm_password`.

**Note** The default `stackstorm_username` is `st2admin`

