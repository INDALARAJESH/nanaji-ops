# Provides a Single Sign-On (SSO) Account Assignment resource

### General

* Description: A module to provide a Single Sign-On (SSO) Account Assignment resource
* Created By: Sebastien Plisson
* Module Dependencies:
  * A SSO identity store
  * A Principal (user or group) in a supported SSO identity store
  * A Permission Set
  * An Account
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-ssoadmin-account-assignment](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ssoadmin-account-assignment/badge.svg)

### Usage

* Terraform:

* Data account example
```hcl
module "account_assignment" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ssoadmin/account-assignment?ref=account-assignment-v2.0.0"

  permission_set_name    = "ViewOnly"
  principal_type         = "group"
  principal_name         = "data"
  account_id             = "475330587555" 

}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                     | Type   | Required? | Notes |
| :------------ | :---------------------------  | :-------------------------- | :----: | :-------: | :---- |
| permission_set_name | name of permission set    |                        | string |  Yes      |       |
| principal_name      | unique user or group name |                        | string |  Yes      | N/A   |
| principal_type      | user or group             |                        | string |  Yes      | N/A   |
| account_id          | account id                |                        | string |  Yes      | N/A   |

#### Outputs


### Lessons Learned

### References
