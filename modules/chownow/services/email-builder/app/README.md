# Email Builder Service App

### General

* Description: Email Builder Service app terraform module
* Created By: Neal Patel
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-email-builder-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-email-builder-base/badge.svg)


### Usage

* Terraform (app module deployment):

```hcl
module "email_builder_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/email-builder/app?ref=cn-email-builder-app-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```


### Initialization


### Terraform

* Run the Email Builder service app module in `email-builder/base` folder
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
            ├──── alb.tf
            ├──── ecs.tf
            └── base
```


### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| service                       | service name                            | email-builder            | string |    Yes    | N/A            |



### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### Resources

* [Email Builder - RFC](https://chownow.atlassian.net/wiki/spaces/CE/pages/2495053847/RFC+Email+Builder+Microservice)
