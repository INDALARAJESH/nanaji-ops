<!-- BEGIN_TF_DOCS -->
# AWS VPC

## General

* Description: AWS VPC Module
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-vpc](https://github.com/ChowNow/ops-tf-modules/workflows/aws-vpc/badge.svg)

## Usage

* Terraform:

```hcl
module "some_vpc" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc?ref=aws-vpc-v2.1.2"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  cidr_block      = "10.21.0.0/16"
  env             = var.env
  private_subnets = ["10.21.0.0/19", "10.21.32.0/19", "10.21.64.0/19"]
  public_subnets  = ["10.21.96.0/19", "10.21.128.0/19", "10.21.160.0/19"]
  vpc_name_prefix = "nc"

  ### optional
  extra_allowed_subnets = ["${data.aws_eip.primary_vpc_ngw.public_ip}/32"]
}
```

## Options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azs | list of chosen Availability Zones | `list(any)` | n/a | yes |
| cidr\_block | VPC CIDR block | `any` | n/a | yes |
| cloudflare\_ingress\_tcp\_allowed | n/a | `list` | ```[ "443" ]``` | no |
| cloudflare\_subnets | list of cloudflare subnets/IPs | `list` | ```[ "173.245.48.0/20", "103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "141.101.64.0/18", "108.162.192.0/18", "190.93.240.0/20", "188.114.96.0/20", "197.234.240.0/22", "198.41.128.0/17", "162.158.0.0/15", "104.16.0.0/13", "104.24.0.0/14", "172.64.0.0/13", "131.0.72.0/22" ]``` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| enable\_classiclink | enable a link between non-VPC instances and those within the VPC. | `bool` | `false` | no |
| enable\_dns\_hostnames | should be true if you want to use private DNS within the VPC | `bool` | `true` | no |
| enable\_dns\_support | should be true if you want to use private DNS within the VPC | `bool` | `true` | no |
| enable\_zone\_private | boolean to enable/disable built in private DNS zone | `number` | `1` | no |
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_allowed\_subnets | list to allow the addition of extra subnets to have access to this vpc | `list` | `[]` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| private\_subnets | list of private subnet CIDR blocks | `list(any)` | n/a | yes |
| public\_subnets | list of public subnet CIDR blocks | `list(any)` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| vpc\_name\_prefix | name prefix to use for VPC | `any` | n/a | yes |
| vpn\_ingress\_tcp\_allowed | n/a | `list` | ```[ "22", "80", "443" ]``` | no |
| vpn\_subnets | n/a | `list` | ```[ "54.183.225.53/32", "54.183.68.210/32", "52.21.177.104/32" ]``` | no |

## Outputs

| Name | Description |
|------|-------------|
| private\_subnet\_ids | n/a |
| public\_subnet\_ids | n/a |
| vpc\_id | n/a |
| vpc\_vpn\_security\_group\_id | n/a |

## Lessons Learned

* Tagging is super important at this level, it will set the tone for other modules to perform data source lookups on subnets, subnet ids, vpc name, etc.

## References

* [Practical VPC Design](https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc)
* [AWS Privatelink](https://chownow.atlassian.net/wiki/spaces/CE/pages/2592964930/AWS+PrivateLink)
<!-- END_TF_DOCS -->
