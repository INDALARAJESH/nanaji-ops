# AWS Security Group - Basic

### General

* Description: A terraform module that creates an AWS security group
* Created By: Joe Perez
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-security-group-basic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-security-group-basic/badge.svg)


### Usage

* Terraform:

```hcl
module "ingress_cloudflare_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.2"

  description = "security group to allow incoming connections from ${var.service} to ${local.env} environment"
  env         = var.env
  env_inst    = var.env_inst
  name_prefix = "ingress"
  service     = var.service
  vpc_id      = var.vpc_id

  ingress_tcp_allowed = ["443"]
  cidr_blocks = [
    "1.1.1.1/32",
    "100.10.244.0/22"
  ]
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name           | Description                        | Options             |  Type  | Required? | Notes |
| :---------------------- | :--------------------------------- | :------------------ | :----: | :-------: | :---- |
| cidr_blocks             | CIDR block list to allow access to |                     | string |    Yes    | N/A   |
| description             | description of security group      |                     | string |    Yes    | N/A   |
| enable_egress_allow_all | boolean to enable egress all       | 1,0                 |  int   |    No     | N/A   |
| env                     | unique environment/stage name      | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst                | iteration of environment           | eg 00,01,02,etc     | string |    No     | N/A   |
| ingress_tcp_allowed     | list of TCP ports                  |                     | string |    No     | N/A   |
| ingress_udp_allowed     | list of UDP ports                  |                     | string |    No     | N/A   |
| ingress_custom_allowed  | list of TCP ports                  |                     | string |    No     | N/A   |
| ingress_custom_protocol | Custom protocol                    |                     | string |    No     | N/A   |
| ingress_custom_self     | Target self                        |                     | string |    No     | N/A   |
| custom_sg_name          | custom security group name         |                     | string |    No     | N/A   |
| name_prefix             | name prefix for security group     |                     | string |    No     | N/A   |
| vpc_id                  | VPC ID to assign security group    | VPC ID              | string |    Yes    | N/A   |

#### Outputs

| Variable Name | Description       |  Type  | Notes |
| :------------ | :---------------- | :----: | :---- |
| id            | security group id | string | N/A   |

### Lessons Learned

* ANY changes to the security group requires a resource rebuild. This means you have to detach the security group from anything that it's assigned to first.


### References
