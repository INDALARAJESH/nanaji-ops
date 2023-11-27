# Cloudflare Security Group

### General

* Description: A terraform module that creates a security group for the whitelisted Cloudflare IPs
* Created By: Joe Perez
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`


### Usage

* Terraform:

```hcl
module "primary_cloudflare_sg" {
source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/cloudflare/security-group?ref=cn-cloudflare-sg-v2.0.1"

  env    = var.env
  vpc_id = data.aws_vpc.primary.id
}
```



### Initialization

### Terraform

* Run the Cloudflare Security Group module in `core` folder
* Example directory structure:

```
stg/
├── global
└── us-east-1
    └── core
        ├── data_source.tf
        ├── provider.tf
        ├── security.tf
        ├── variables.tf
        └── vpc.tf
```

  * `security.tf`
```hcl
module "primary_cloudflare_sg" {
source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/cloudflare/security-group?ref=cn-cloudflare-sg-v2.0.0"

  env    = var.env
  vpc_id = data.aws_vpc.primary.id
}
```

* Example cloudflare security group attachment:

```hcl
data "aws_security_group" "ingress_cloudflare" {
  filter {
    name   = "tag:Name"
    values = ["ingress-cloudflare-${local.env}"]
  }
}

module "alb" {
  source = "../../../etc"

  ...
  ...
  security_group_ids = [
    "${data.aws_security_group.ingress_cloudflare.id}",
  ]
}


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                     | Options             |  Type  | Required? | Notes |
| :------------ | :------------------------------ | :------------------ | :----: | :-------: | :---- |
| env           | unique environment/stage name   | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst      | iteration of environment        | eg 00,01,02,etc     | string |    No     | N/A   |
| vpc_id        | VPC ID to assign security group | VPC ID              | string |    Yes    | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### References
