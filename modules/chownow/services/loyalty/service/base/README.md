# Loyalty Service Base

### General

* Description: Loyalty Service base terraform module.
  This module creates resources used by the loyalty service.
* Created By: Warren Nisley
* Module Dependencies:
* Module Components: `loyalty-service-base`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-loyalty-service-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-loyalty-service-base/badge.svg)

### Usage

* Terraform:

```hcl
module "loyalty_service_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/loyalty/service/base?ref=loyalty-service-base-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```



### Initialization

### Terraform

* Run the Loyalty service base module in `loyalty/service/base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── loyalty
          └── base
          └── pipeline
            ├── base
            └── app
          └── service
            └── base
                ├── data_sources.tf
                ├── secrets.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| service                       | service name                            | loyalty-service          | string |    Yes    | N/A            |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References

* [Loyalty Service - Confluence](https://chownow.atlassian.net/wiki/spaces/CE/pages/2240742157/ChowNow+Loyalty+Service)
