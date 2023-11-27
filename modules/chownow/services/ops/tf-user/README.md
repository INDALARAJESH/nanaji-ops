# Terraform User Module

### General

* Description: Creates AWS IAM user(s) to provision resources in other AWS accounts
* Created By: Joe Perez
* Module Dependencies:
  * `N/A`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-tf-user](https://github.com/ChowNow/ops-tf-modules/workflows/cn-tf-user/badge.svg)

### Usage

* Terraform (basic):

```
module "tf_user" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/ops/tf-user?ref=cn-tf-user-v2.0.0"

  env = var.env
}
```

### Create Access Key for User

* create access key: `aws-vault exec ops -- aws iam create-access-key --user svc_tf-user-production`
* Put access/secret key in environment's 1Password Vault
* Add keys to Jenkins

## Module Options


### Inputs

| Variable Name | Description       | Options        | Type   | Required? | Notes |
| ------------- | ----------------- | -------------- | ------ | --------- | ----- |
| env           | environment/stage | default: `ops` | string | Yes       | N/A   |




### Outputs

| Variable Name | Description | Type | Notes |
| ------------- | ----------- | ---- | ----- |



### Lessons Learned

* Using the `jsonencode` in an IAM policy document doesn't always render the policy nicely, it sometimes replaces earlier statements in policies that define multiple statements. This shows up in the official terraform docs, but it seems buggy. I would recommend using a template file or the HCL version of an IAM policy
### Resources
