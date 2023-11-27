# Global Security Base

### General

* Description: The module used to set up base resources for AWS account security
* Created By: Jobin Muthalaly
* Module Dependencies: `aws-security-root-login-v1.0.0`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-global-security-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-global-security-base/badge.svg)

### Usage

```hcl
module "security_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/global/security/base?ref=cn-global-security-base-v2.0.2"

  env = var.env
}
```

### Changelog

* v2.0.1 - Adding patch manager
* v2.0.2 - Adding patch manager scheduling inputs

#### Inputs

| Variable Name                | Description                                  | Options                     | Type   | Required? | Notes |
| ---------------------------- | -------------------------------------------- | --------------------------- | ------ | --------- | ----- |
| env                          | environment/stage                            | uat, qa, qa00, stg, prod    | string | Yes       | N/A   |
| env_inst                     | environment instance                         | 00, 01, 02                  | string | No        | N/A   |
| service                      | environment instance                         | service name                | string | No        | N/A   |
| environment_tag_list         | tag values for patch manager to scan against | a list of environment names | list   | No        | N/A   |
| patch_manager_patch_schedule | cron schedule for patching                   | cron                        | string | No        | N/A   |
| patch_manager_scan_schedule  | cron schedule for scans                      | cron                        | string | No        | N/A   |

#### Outputs

#### Notes
