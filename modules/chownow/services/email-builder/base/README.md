# Email Builder Service Base

### General

* Description: Email Builder Service base terraform module
* Created By: Neal Patel
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-email-builder-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-email-builder-base/badge.svg)


### Usage

* Terraform (base module deployment):

```hcl
module "email_builder_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/email-builder/base?ref=cn-email-builder-base-v2.0.6"

  env      = var.env
  service  = var.service
}
```


### Initialization


### Terraform

* Run the Email Builder service base module in `email-builder/base` folder
* Example directory and terraform workspace structure:

`ops/terraform/environments/ENV`
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── email-builder
            ├── app
            └── base
                ├── ecr.tf
                ├── variables.tf
```


### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| service                       | service name                            | email-builder            | string |    Yes    | N/A            |


### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### Resources

* [Email Builder - RFC](https://chownow.atlassian.net/wiki/spaces/CE/pages/2495053847/RFC+Email+Builder+Microservice)