# Matillion Base

### General

* Description: Matillion base terraform module. This module creates the public ALB and other resources which are required before creating the matillion application
* Created By: Joe Perez
* Module Dependencies: `alb-public`, `alb-listener-rule` `alb-target-group`
* Module Components: `matillion alb`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-matillion-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-matillion-base/badge.svg)

### Usage

* Terraform:

```hcl
module "matillion_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/matillion/base?ref=matillion-base-v2.0.1"

  env = "data"
}
```



### Initialization

### Terraform

* Run the Matillion base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── matillion
            └── base
                ├── matillion_base.tf
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
| service                       | service name                            | matillion                | string |    No     | N/A            |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References

* [Matillion Infrastructure - Confluence](https://chownow.atlassian.net/wiki/spaces/CE/pages/2066612405/Matillion+Infrastructure)
