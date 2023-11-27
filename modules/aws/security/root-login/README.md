# Security - Root Login

### General

* Description: A module to send alerts and log Root user logins
* Created By: Jobin Muthalaly
* Module Dependencies: `none`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-security-root-login](https://github.com/ChowNow/ops-tf-modules/workflows/aws-security-root-login/badge.svg)

### Usage

```hcl
module "root_login" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security/root-login?ref=aws-security-root-login-v2.0.0"
  env    = var.env
}
```

#### Inputs

| Variable Name             | Description             | Options                  | Type           | Required? | Notes |
| ------------------------- | ----------------------- | ------------------------ | -------------- | --------- | ----- |
| env                       | environment/stage       | uat, qa, qa00, stg, prod | string         | Yes       | N/A   |
| env_inst                  | environment instance    | 00, 01, 02               | string         | No        | N/A   |
| service                   | environment instance    | service name             | string         | No        | N/A   |
| alert_subscription_emails | emails for login alerts | emails                   | set of strings | No        |       |


#### Outputs
| Variable Name | Description          | Options                  | Type   | Required? | Notes |
| ------------- | -------------------- | ------------------------ | ------ | --------- | ----- |
| log_group_name| module log group name|           N/A            | string | Yes       | N/A   |

#### Notes
