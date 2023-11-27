# Pritunl App Module

### General

* Description: This module creates the base level resources necessary for the Prtiunl VPN stack.
* Created By: Jobin Muthalaly
* Module Dependencies:
  * `N/A`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x
* AWS Provider Version: 4.0

![chownow-services-pritunl-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-pritunl-app/badge.svg)

### Usage, Latest Version

* Terraform:

```hcl
module "pritunl_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/pritunl/base?ref=cn-pritunl-app-v2.0.0"

}
```


### Terraform

* Example directory structure: `ops/terraform/environments/ops/us-east-1/services/pritunl`
```
├── app
│   ├── env_global.tf -> ../../../../env_global.tf
│   ├── pritunl_app.tf
│   └── provider.tf
├── base
│   ├── env_global.tf -> ../../../../env_global.tf
│   ├── pritunl_base.tf
│   └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name           | Description                                       | Options      |  Type  | Required? | Notes |
| :-----------------------| :------------------------------------------------ | :----------- | :----: | :-------: | :---- |



#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


