# Provides a Single Sign-On (SSO) Managed Policy Attachment

### General

* Description: A module to provide a Single Sign-On (SSO) Managed Policy Attachment
* Created By: Sebastien Plisson
* Module Dependencies:
  * A SSO identity store
  * An IAM policy
  * A Permission Set
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-ssoadmin-permission-set-with-policy-attachment](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ssoadmin-permission-set-with-policy-attachment/badge.svg)

### Usage

* Terraform:

* View-Only example
```hcl
module "permission_set_with_policy_attachment" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ssoadmin/permission-set-with-policy-attachment?ref=aws-ssoadmin-permission-set-with-policy-attachment-v2.0.1"

  permission_set_name           = "ViewOnly"
  iam_policy_arn                = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                     | Type   | Required? | Notes |
| :------------ | :---------------------------  | :-------------------------- | :----: | :-------: | :---- |
| permission_set_name | name of permission set       |                        | string |  Yes      |       |
| iam_policy_arn      | arn of IAM policy to attach  |                        | string |  Yes      |       |

#### Outputs


### Lessons Learned

### References
