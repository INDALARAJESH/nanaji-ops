# YOURSERVICENAME Service App

### General

* Description: YOURSERVICENAME Service app terraform module
* Created By: YOURNAMEGOESHERE
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-YOURSERVICENAME-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-YOURSERVICENAME-base/badge.svg)


### Usage

* Terraform (app module deployment):

```hcl
module "YOURSERVICENAME_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/YOURSERVICENAME/app?ref=cn-YOURSERVICENAME-app-v2.0.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```


### Initialization


### Terraform

* Run the YOURSERVICENAME service app module in `YOURSERVICENAME/base` folder
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
        └── YOURSERVICENAME
            ├── app
            │   ├── env_global.tf -> ../../../../env_global.tf
            │   ├── YOURSERVICENAME_app.tf
            │   └── provider.tf
            └── base
```


### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| service                       | service name                            | YOURSERVICENAME            | string |    Yes    | N/A            |



### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### Resources

* [YOURSERVICENAME - RFC](https://google.com)
