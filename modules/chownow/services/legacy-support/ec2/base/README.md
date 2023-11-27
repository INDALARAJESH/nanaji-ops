# Legacy Support EC2 Base

### General

* Description: Creates secrets and IAM resources to support incomplete legacy ec2 deployments
* Created By: Joe Perez
* Module Dependencies:
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-legacy-support-ec2-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-legacy-support-ec2-base/badge.svg)


### Usage

* Example directory structure:

├── global
└── us-east-1
    └── services
        └── legacy-support
            └── ec2
                └── base
                    ├── env_global.tf -> ../../../../../env_global.tf
                    ├── legacy_support_ec2_base.tf
                    └── provider.tf


* Terraform:

`legacy_support_ec2_base.tf`
```hcl
module "legacy_support_ec2_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/legacy-support/ec2/base?ref=cn-legacy-support-ec2-base-v2.0.0"

  env = var.env
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                    |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :------------------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name | sb/dev/qa/uat/stg/prod/etc | string |    Yes    | N/A   |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

* Decided to create one generalized module to support each of the different legacy ec2 deployments. They all require an IAM profile/role, SSM policy and common secrets (Threatstack, Datadog, etc)


### References
