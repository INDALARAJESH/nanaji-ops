# Sysdig Secure - Base

### General

* Description: This module creates the base resources needed for Sysdig in an environment.
* Created By: Jobin Muthalaly
* Module Dependencies:
  * `N/A`
* Provider Dependencies: `aws`
* Terraform Version: 1.5.0
* AWS Provider Version: ~> 5.0.1

![chownow-services-sysdig-secure-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-sysdig-secure-base/badge.svg)

### Usage, Latest Version

* Terraform:

```hcl
module "sysdig_secure_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/sysdig-secure/base?ref=cn-sysdig-secure-base-v3.0.0"

  env = var.env
}
```


### Terraform

* Example directory structure: `ops/terraform/environments/dev/us-east-1/services/sysdig-secure`
```
├── base
│   ├── env_global.tf -> ../../../../env_global.tf
│   ├── base.tf
│   └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name           | Description                     | Options      |  Type  | Required? | Notes |
| :-----------------------| :-------------------------------| :----------- | :----: | :-------: | :---- |
| env                     | unique environment/stage name   | ex: "dev"    | string | Yes       | N/A   |



#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


