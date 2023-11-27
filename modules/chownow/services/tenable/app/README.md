# Tenable

### General

* Description: Tenable app
* Created By: DevOps
* Module Dependencies: `vpc`, `tenable-base`
* Provider Dependencies: `aws`, `template`

![chownow-services-tenable-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-tenable-app/badge.svg)

### Terraform

```hcl
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── tenable
            └── app
                ├── tenable_app.tf
                ├── provider.tf
                └── variables.tf
```

* `tenable_app.tf`

```hcl
data "aws_vpcs" "in_region" {}

data "aws_vpc" "selected" {
  for_each = toset(data.aws_vpcs.in_region.ids)
  id = each.value
}

variable "excluded_vpc_list" {
    description = "list of VPCs to exclude from provisioning"
    default = ["do-not-use"]
}

locals {
    vpc_map = { for vpc_id,vpc_info in data.aws_vpc.selected :
                    vpc_info.tags["Name"] => vpc_id }
    vpc_names = [for vpc_name,vpc_id in local.vpc_map :
                    vpc_name if ! contains(var.excluded_vpc_list, vpc_name)]
}

module "tenable_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/tenable/app?ref=cn-tenable-app-v2.0.4"

  for_each = toset(local.vpc_names)

  env      = var.env
  vpc_name = each.value
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name   | Description                   | Options               |  Type  | Required? | Notes |
| :-------------- | :---------------------------- | :-------------------- | :----: | :-------: | :---- |
| env             | unique environment/stage name | pde-stg pde-prod      | string |    Yes    | N/A   |
| env_inst        | environment instance          | 00/01/02/...          | string |    No     | N/A   |
| service         | name of ECS service           | default: tenable      | string |    No     | N/A   |
| vpc_name        | vpc name                      | ex: main              | string |    Yes    | N/A   |
| ami_id          | AMI for Nessus Scanner        | ex: ami-0fbfded1xxxxx | string |    Yes    | N/A   |
| instance_type   | instance size                 | ex: t2.xlarge         | string |    Yes    | N/A   |


### Complete Provisioning
1. Log into [tenable](https://cloud.tenable.com/#/)
2. Go to [Tenable Scanner List](https://cloud.tenable.com/tio/app.html#/settings/sensors/nessus/scanners-list) and verify that you see the new scanner/instance that you just provisioned
3. Go to scans and copy a current "Weekly" scan
4. Edit copied scan and replace the name and scanner with the newly provisioned scanner/instance
5. Run Scan to verify that it works.
   1. You will also need to make sure the same public key as the one in the `chownow.tenable_client` ansible role is located on any of the hosts that need to be scanned

#### Outputs


### Lessons Learned

* Must have an instance size that is compatible with AWS marketplace subscription, Change tenable_instance_type accordingly to prevent errors
* The appliance/scanner gets its key to connect to the tenable web interface via the `/env/tenable/api` secrets manager secret, then it's injected via ec2 `user-data`
* If you get the error below, chances are, the region has a VPC that doesn't have a name. Delete the VPC or give it a tag Name like "do-not-use":

```bash
Error: Invalid index

  on tenable_app.tf line 16, in locals:
  16:                     vpc_info.tags["Name"] => vpc_id }
    |----------------
    | vpc_info.tags is empty map of string

The given key does not identify an element in this collection value.
```



### References

* [Tenable Scanner List (must be logged in)](https://cloud.tenable.com/tio/app.html#/settings/sensors/nessus/scanners-list)
* [Tenable AWS Documentation](https://docs.tenable.com/integrations/AWS/Content/Welcome.htm)
* [Confluence Tenable Documentation](https://chownow.atlassian.net/wiki/spaces/CE/pages/564920384/Tenable+Vulnerability+Management#TenableVulnerabilityManagement-AWS.1)
