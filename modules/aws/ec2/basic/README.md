# EC2 Instance Module

### General

* Description: Terraform EC2 Module
* Created By: Joe Perez
* Module Dependencies: core
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-ec2-basic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ec2-basic/badge.svg)


### Usage

* Terraform (basic):


`web.tf`
```hcl
module "web" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.7"

  env                 = var.env
  ingress_tcp_allowed = ["22", "80", "443"]
  service             = "hermosa"
  vpc_name_prefix     = "main"
}
```

* Terraform (custom AMI):

```hcl
module "ec2" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.7"

  custom_ami_id       = "ami-1234567890"
  env                 = var.env
  ingress_tcp_allowed = ["80", "443"]
  service             = "matillion"
  vpc_name_prefix     = "main"
}
```

* Terraform (custom VPC):

```hcl
module "web" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.7"

  custom_vpc_name     = "new-vpc"
  env                 = var.env
  ingress_tcp_allowed = ["80", "443"]
  service             = "hermosa"
}
```

* Terraform (custom instance name):

```hcl
module "web" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.7"

  custom_instance_name = "fire" # formatted as fire0-ENV
  custom_vpc_name      = "new-vpc"
  env                  = var.env
  ingress_tcp_allowed  = ["80", "443"]
  service              = "emoji"
}
```


## Module Options


### Inputs

| Variable Name               | Description                                 | Options                            | Type     | Required? | Notes |
| --------------------------- | ------------------------------------------- | ---------------------------------- | -------- | --------- | ----- |
| associate_public_ip_address | enable the ability to attach public IP      | true or false (default: false)     | Boolean  | No        | N/A   |
| custom_ami_id               | custom AMI ID                               | AMI ID (default: "")               | String   | No        | N/A   |
| custom_iam_instance_profile | custom iam profile                          | Profile name (default: "")         | String   | No        | N/A   |
| custom_instance_name        | custom instance name to override default    | any name (default: "")             | String   | No        | N/A   |
| custom_key_pair             | custom key pair to use for ec2 instance(s)  | key pair name (default: "")        | String   | No        | N/A   |
| custom_user_data            | custom user data                            | User data (default: "")            | Template | No        | N/A   |
| custom_vpc_name             | custom vpc name for resource placement      | VPC Name (default: "")             | String   | No        | N/A   |
| domain_name                 | domain name to be appended to fqdn          | example.com (default: chownow.com) | String   | No        | N/A   |
| enable_dns_record_private   | enables/disables creation of private record | 1 or 0 (default: 1)                | String   | No        | N/A   |
| enable_dns_record_public    | enables/disables creation of public record  | 1 or 0 (default: 1)                | String   | No        | N/A   |
| env                         | environment/stage                           | uat, qa, stg, prod                 | String   | Yes       | N/A   |
| env_inst                    | environment instance, eg 01 added to stg01  | 00, 01, 02, etc                    | String   | No        | N/A   |
| ingress_tcp_allowed         | list of inbound TCP ports to allow          | (default: [])                      | List     | No        | N/A   |
| instance_count              | number of instances                         | 1--->1000000 (default: 1)          | Int      | No        | N/A   |
| instance_type               | AWS instance type                           | Instance type (default: t3.micro)  | String   | No        | N/A   |
| root_volume_size_gb         | size of root volume                         | number in GB (default: 32)         | Int      | No        | N/A   |
| security_group_ids          | security groups to associate with instance  | list of security group IDs         | List     | Yes       | N/A   |
| service                     | unique service name                         | hermosa, ops, etc                  | String   | Yes       | N/A   |
| tag_managed_by              | managed by tag                              | name (default: Terraform)          | String   | No        | N/A   |



### Outputs

| Variable Name     | Description                                     | Type   | Notes |
| ----------------- | ----------------------------------------------- | ------ | ----- |
| ec2_iam_role_name | ec2 role for atttaching additional IAM policies | string | N/A   |
| ids               | List of instance IDs                            | list   | N/A   |
| private_ips       | List of instance private IPs                    | list   | N/A   |
| public_ips        | List of instance public IPs                     | list   | N/A   |


### Resources

### Learning
