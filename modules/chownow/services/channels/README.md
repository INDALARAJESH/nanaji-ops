# Channels Module

## Migration Notes

### 2.4.0
When upgrading to version 2.4.0 from any version, some previously static resources are now conditionally created:
- module.channels.module.user_svc_seated.aws_iam_user_policy.service
- module.channels.module.user_svc_seated.aws_iam_user.service

Currently Terraform has a limitation where all conditionally created resources are lists (with potentially 0 items), which means that Terraform will delete and recreate these two objects even if you make no changes to them.

To resolve the default case of no changes:
- `terraform state mv module.channels.module.user_svc_seated.aws_iam_user_policy.service module.channels.module.user_svc_seated[0].aws_iam_user_policy.service`
- `terraform state mv module.channels.module.user_svc_seated.aws_iam_user.service module.channels.module.user_svc_seated[0].aws_iam_user.service`

### General

* Description: Hermosa Channels module
* Created By: Tim Ho
* Module Dependencies: N/A
* Provider(s): `aws`

### Usage

* Terraform (basic):

```hcl
module "channels" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/channels?ref=hermosa-channels-v2.4.1"

  env = "${var.env}"
}

```

## Module Options

### Inputs
| Variable Name                 | Description                                                              | Options                 |  Type        | Required? | Notes  |
| ----------------------------- |--------------------------------------------------------------------------| ------------------------| ------------ | --------- |--------|
| cn_seated_s3_bucket_name      | ChowNow owned s3 bucket for lower env testing                            | Any string              | string       | No        | N/A    |
| enable_nextdoor               | Switch for enabling nextdoor resources, defaults `true`                  | true/false              | bool         | No        | N/A    |
| enable_rewards_network        | Switch for enabling rewards network resources, defaults `true`           | true/false              | bool         | No        | N/A    |
| enable_seated                 | Switch for enabling seated resources, defaults `true`                    | true/false              | bool         | No        | N/A    |
| enable_seated_external        | Switch for enabling public seated resources, prod only, defaults `false` | true/false              | bool         | No        | N/A    |
| enable_snapchat               | Switch for enabling nextdoor resources, defaults `true`                  | true/false              | bool         | No        | N/A    |
| env                           | Unique environment/stage name                                            | uat, dev, qa, stg, prod | string       | Yes       | N/A    |
| env_inst                      | Environment instance, eg 01 added to stg01, defaults empty string        | Env-specific            | string       | No        | N/A    |
| nextdoor_aws_account_ids      | List of AWS account ids used in allowlist on nextdoor bucket             | AWS account id list     | List[string] | No        | N/A    |
| nextdoor_s3_bucket_name       | Nextdoor-owned s3 bucket name                                            | Any string              | string       | No        | N/A    |
| rewards_network_s3_principals | Allowlist for rewards network bucket policy                              | IAM principal list      | List[string] | No        | N/A    |
| service                       | Service name for project/application                                     | hermosa                 | string       | No        | N/A    |
| snapchat_iam_assumerole_arn   | Snapchat iam role id (assume_role)                                       | valid iam role id       | string       | No        | N/A    |
| snapchat_is_test_env          | Toggle to create test aws resources                                      | true/false              | bool         | No        | N/A    |
| s3_object_expiration_days     | Number of days to keep objects                                           |                         | int          | No        | N/A    |

## Notes

- Test AWS resources were introduced as a means to attempt to replicate the workflow that Snapchat has employed. Snapchat has not provided us with a sandbox account in which our lower environments can point to, so this module creates the resources required to mirror the desired workflow. Only production/staging environments have established trust relationships with the Snapchat production AWS IAM role, so it is assumed that all other environments (dev/uat/qa etc.) will want to create these resources for testing purposes. To enable the creation of the testing resources, `snapchat_is_test_env = true` should be specified as a module argument.
