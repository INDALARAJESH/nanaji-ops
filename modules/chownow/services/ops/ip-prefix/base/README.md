# ChowNow Shared Public IP Prefix lists

### General

* Description: A module to create the AWS RAM shared IP Prefix lists to the entire AWS Organization
* Created By: Joe Perez
* Module Dependencies:
  * AWS RAM must be enabled at the AWS Organization level
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-ip-prefix-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-ip-prefix-base/badge.svg)

### Usage


#### Terraform

* Terraform:

`ops>terraform>environments`

```
ops
├── global
└── us-east-1
    └── services
        └── ops
            └── ip-prefix
                └── base
                    ├── data_source.tf
                    ├── ip_prefix_base.tf
                    ├── provider.tf
                    └── variables.tf
```

* IP Prefix Base example:

`base.tf`
```hcl
module "ip_prefix_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/ops/ip-prefix/base?ref=cn-ip-prefix-base-v2.0.0"

  env        = var.env
  nat_gw_ips = local.nat_gw_ips

}
```

`variables.tf`
```hcl
locals {
  # Take the NAT gateway IPs from the data source lookup and put it in CIDR notation,
  # which is an IP prefix resource requirement
  data_nat_gw_ips = [for i in data.aws_nat_gateway.data[*].public_ip : "${i}/32"]
  dev_nat_gw_ips  = [for i in data.aws_nat_gateway.dev[*].public_ip : "${i}/32"]
  ncp_nat_gw_ips  = [for i in data.aws_nat_gateway.ncp[*].public_ip : "${i}/32"]


  # Create map for each environment and feed it to the IP Prefix Module
  nat_gw_ips = {
    data = {
      "name"            = "cn-public-ipv4-natgw-data"
      "description"     = "Chownow data account NAT Gateway IPs"
      "ips"             = local.data_nat_gw_ips
      "tag_environment" = "data"
    }
    dev = {
      "name"            = "cn-public-ipv4-natgw-dev"
      "description"     = "Chownow dev account NAT Gateway IPs"
      "ips"             = local.dev_nat_gw_ips
      "tag_environment" = "dev"
    }
    ncp = {
      "name"            = "cn-public-ipv4-natgw-ncp"
      "description"     = "Chownow ncp account NAT Gateway IPs"
      "ips"             = local.ncp_nat_gw_ips
      "tag_environment" = "ncp"
    }
  }
}
```
_Note: Example has been shortened to make it easier to read_


`data_source.tf`
```hcl
data "aws_nat_gateways" "dev" {
  provider = aws.dev

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_nat_gateway" "dev" {

  provider = aws.dev
  count    = length(data.aws_nat_gateways.dev.ids)
  id       = tolist(data.aws_nat_gateways.dev.ids)[count.index]
}


data "aws_nat_gateways" "data" {
  provider = aws.data

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_nat_gateway" "data" {

  provider = aws.data
  count    = length(data.aws_nat_gateways.data.ids)
  id       = tolist(data.aws_nat_gateways.data.ids)[count.index]
}


data "aws_nat_gateways" "ncp" {
  provider = aws.ncp

  filter {
    name   = "state"
    values = ["available"]
  }
}
```


`provider.tf`
```hcl
terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-ops"
    key    = "ops/us-east-1/services/ops/ip-prefix/base/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace = "ops/terraform/environments/ops/us-east-1/services/ops/ip-prefix/base"
    }
  }

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  required_version = "~> 0.14.7"
}


provider "aws" {
  alias  = "data"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::475330587555:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias  = "dev"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::229179723177:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias  = "ncp"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::595631937550:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name   | Description                       | Options |  Type  | Required? | Notes |
| :-------------- | :-------------------------------- | :------ | :----: | :-------: | :---- |
| env             | unique environment/stage name     |         | string |    Yes    | N/A   |
| nat_gateway_ips | map of AWS NAT Gateway Public IPs | {}      |  map   |    Yes    | N/A   |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned

* Complexity either happens inside or outside the module, due to the nature of this request. I (Joe) have opted to have the complexity on the outside or workspace side of this work. This allows us to more quickly add new environments and see the data construction prior to passing into the module. This also allows changes to happen without modifying the module itself.

### References

* [Using AWS RAM IP Prefix Lists](https://chownow.atlassian.net/wiki/spaces/CE/pages/2780561562/Using+AWS+RAM+IP+Prefix+Lists)
