# Loyalty Base

### General

* Description: Loyalty base terraform module.
  This module creates resources shared between the loyalty service and pipeline.
* Created By: Warren Nisley
* Module Dependencies:
* Module Components: `loyalty-base`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-loyalty-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-loyalty-base/badge.svg)

### Usage

* Terraform:

```hcl
module "loyalty_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/loyalty/base?ref=loyalty-base-v2.1.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```



### Initialization

### Terraform

* Run the Loyalty base module in `base` folder
* Example directory structure:

├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── loyalty
          └── base
            ├── data_sources.tf
            ├── dynamodb.tf
            ├── iam.tf
            └── variables.tf
          └── pipeline

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| service                       | service name                            | loyalty | string         |    No  |    N/A    | N/A            |
| read_capacity                 | Read capacity for dynamodb table        | (Default: 20)            | string |    No     | N/A            |
| write_capacity                | Write capacity for dynamodb table       | (Default: 20)            | string |    No     | N/A            |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References

* [Loyalty Pipeline - Confluence](https://chownow.atlassian.net/wiki/spaces/CE/pages/2225504257/Loyalty+-+Salesforce+integration+pipeline)
