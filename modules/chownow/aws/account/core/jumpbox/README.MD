# ChowNow per-VPC Jumpbox

### General

This module exists to be the new place for jump box configuration to live.  Jump box promises are:

- Every VPC in every region should have one, and only one, jump box that can be accessed with `aws ssm start-session`.
- Every jump box has no public IP, but can access the internet through a NAT device for installing packages and querying external services on behalf of local services.
- DevOps will maintain a set of configuration that provides least-privilege access to jump boxes in accordance with the permissions outlined in https://chownow.atlassian.net/wiki/spaces/~107707246/pages/2607349874/Pitch+Developer+AWS+Permissions+Matrix
- Every component in every service will be reachable from the jump boxes in accordance with a to-be-written confluence article detailing components and access mechanisms.
- DevOps treats these access mechanisms as if they were production resources and guarantees their availability.

* Created By: Rob St. Marie
* Provider Dependencies: `aws`
* Terraform Version: `0.14.11`

![chownow-service-jumpbox](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-service-jumpbox/badge.svg)

## Latest Version
```
git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/jumpbox?ref=cn-jumpbox-v2.1.6
```

2.0.0: Initial commit.
2.0.1: Temporarily ignoring changes on vpc_security_group_ids until we can create a jumpbox-owned membership and access SG.
2.0.2: Adding jumpbox custom names to allow for qa0x jumpboxes. You can use the custom_name variable for this
2.1.0: Refactored module, adding missing VPC and other tags


## Usage

```bash
$ENV
├── env_global.tf
├── global
└── us-east-1
    ├── base
    └── core
        ├── base
        ├── jumpbox
        │   ├── env_global.tf -> ../../../env_global.tf
        │   ├── jumpbox.tf
        │   └── provider.tf
        └── vpc
```


* Deploying to multiple VPCs in an environment:

`jumpbox.tf`
```hcl
locals {
  vpcs = {
   dev = {
      env      = var.env
      vpc_name = "dev"
    }
   main-dev = {
      env      = var.env
      vpc_name = "main-dev"
    }
   nc-dev = {
      env      = var.env
      vpc_name = "nc-dev"
    }
   ab-dev = {
      env      = var.env
      vpc_name = "ab-dev"
    }
  }
}


module "jumpbox_app" {
  source    = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/jumpbox/app?ref=cn-jumpbox-v2.1.6"

  for_each = local.vpcs

  env      = each.value.env
  vpc_name = each.value.vpc_name
}

module "jumpbox_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/jumpbox/base?ref=cn-jumpbox-v2.1.6"

  env = var.env
}

```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                        | Options                             |  Type  | Required? | Notes |
| :------------------------- | :--------------------------------- | :---------------------------------- | :----: | :-------: | :---- |
| env                        | unique environment/stage name      | sandbox/dev/qa/uat/stg/prod/etc     | string |    Yes    | N/A   |
| env_inst                   | instance of an environment         | a two digit number, 00, 01, 02, etc | string |    No     | N/A   |
| service                    | name of service                    | default: jumpbox                    | string |    No     | N/A   |
| vpc_name                   | name of vpc for resource placement |                                     | string |    Yes    | N/A   |
| additional_security_groups | additional security groups         |                                     |  list  |    No     | N/A   |


#### Outputs

| Variable Name                             | Description                            | Type  | Notes |
| :---------------------------------------- | :------------------------------------- | :---: | :---- |
| ec2_instance.primary_network_interface_id | network ID to attach to security group | list  | N/A   |

### Lessons Learned

* Grouping jumpboxes together like this makes them easier to maintain. They all have the same tags and they can be rebuilt/patched without interfering with other resources


### References
