# SERVICENAMEGOESHERE Service Base

### General

* Description: SERVICENAMEGOESHERE Service base terraform module
* Created By: YOURNAMEGOESHERE
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-SERVICENAMEGOESHERE-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-SERVICENAMEGOESHERE-base/badge.svg)


### Usage

* Terraform (base module deployment):

```hcl
module "SERVICENAMEGOESHERE_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/SERVICENAMEGOESHERE/base?ref=cn-SERVICENAMEGOESHERE-base-v2.0.0"

  env      = var.env
  service  = var.service
}
```


### Initialization


### Terraform

* Run the service base module in `SERVICENAMEGOESHERE/base` folder
* Example directory and terraform workspace structure:

`ops/terraform/environments/ENV`
```
├── env_global.tf
├── global
└── us-east-1
    ├── base
    ├── core
    ├── db
    └── services
        └── SERVICENAMEGOESHERE
            ├── app
            └── base
                ├── env_global.tf -> ../../../../env_global.tf
                ├── SERVICENAMEGOESHERE_base.tf
                └── provider.tf
```


### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| service                       | service name                            | SERVICENAMEGOESHERE            | string |    Yes    | N/A            |


### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### Resources

* [SERVICENAMEGOESHERE - RFC](https://chownow.atlassian.net/wiki/)
