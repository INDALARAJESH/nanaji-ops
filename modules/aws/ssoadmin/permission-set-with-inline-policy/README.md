# Provides a Single Sign-On (SSO) Permission Set with Inline Policy

### General

* Description: A module to provide a Single Sign-On (SSO) Permission Set with Inline Policy
* Created By: Sebastien Plisson
* Module Dependencies:
  * A SSO identity store
  * An IAM policy document json
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-ssoadmin-permission-set-with-inline-policy](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ssoadmin-permission-set-with-inline-policy/badge.svg)

### Usage

* Terraform:

* Custom example
```hcl
module "permission_set_with_inline_policy" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ssoadmin/permission-set-with-policy-attachment?ref=aws-ssoadmin-permission-set-with-inline-policy-v2.0.2"

  permission_set_name           = "Custom"
  iam_policy_document_json      = data.aws_iam_policy_document.example.json
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name            | Description                           | Options       |  Type  | Required? | Notes |
| :----------------------- | :------------------------------------ | :------------ | :----: | :-------: | :---- |
| permission_set_name      | name of permission set                |               | string |    Yes    |       |
| iam_policy_document_json | IAM policy document's json to include |               | string |    Yes    |       |
| session_duration         | session timeout duration              | default: PT1H | string |    No     |       |

#### Outputs


### Lessons Learned

### References
