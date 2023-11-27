# Revenue.io Base

### General

* Description: Revenue.io base Terraform module. This module creates the resources needed for the Revenue.io service.
* Created By: Jobin Muthalaly
* Module Dependencies: `s3-base`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-revenue-io-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-revenue-io-base/badge.svg)

### Usage

* Terraform:

```hcl
module "revenue_io_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/revenue-io/base?ref=revenue-io-base-v2.0.1"

  env = "data"
}
```



### Initialization

### Terraform

* Run the Revenue.io base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── revenue-io
            └── base
                ├── revenue_io_base.tf
                ├── provider.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| enable_bucket_revenue_io      | toggle revenue-io bucket creation       | 0 or 1 (default: 0)      | int    |    Yes    | N/A            |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


