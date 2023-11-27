# appsmith Service Base

### General

* Description: appsmith Service base terraform module
* Created By: Anshul Puri
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-appsmith-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-appsmith-base/badge.svg)


### Usage

* Terraform (base module deployment):

```hcl
module "appsmith_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/appsmith/base?ref=cn-appsmith-base-v2.1.1"

  env      = var.env
  service  = var.service
}
```


### Initialization


### Terraform

* Run the service base module in `appsmith/base` folder
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
        └── appsmith
            ├── app
            └── base
                ├── env_global.tf -> ../../../../env_global.tf
                ├── appsmith_base.tf
                └── provider.tf
```


### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| service                       | service name                            | appsmith            | string |    Yes    | N/A            |


### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

Uses the cluster now. Check app/README for info on how to set this up once Terraform is run.

The key is referenced as a datasource, but also requires a public key to be local here. I made it manually, then Terraform replaced that value after I got the public key and placed it in this path. The solution here is to make a db module and do the mongodb stuff in that module instead of all in base.

Some of these secrets values in mongodb.tf are not used, but they are left there for now. They do nothing and are not vulnerable, but they are referenced elsewhere. Should be reworked later.

### Resources

* [appsmith - RFC](https://chownow.atlassian.net/wiki/)
