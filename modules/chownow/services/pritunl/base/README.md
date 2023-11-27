# Pritunl Base Module

### General

* Description: This module creates the base level resources necessary for the Prtiunl VPN stack.
* Created By: Jobin Muthalaly
* Module Dependencies:
  * `aws-s3-base-v2.0.3`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x
* AWS Provider Version: 4.0

![chownow-services-pritunl-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-pritunl-base/badge.svg)

### Usage, Latest Version

* Terraform:

```hcl
module "pritunl_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/pritunl/base?ref=cn-pritunl-base-v2.0.1"

  env      = var.env
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
| vpn_udp_allowed_sources | List of CIDRs to allow web access through the ALB | list(any)    |  List  |    No     | N/A   |




#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

