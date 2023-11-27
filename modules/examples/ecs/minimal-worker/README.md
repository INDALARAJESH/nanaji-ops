# YOURSERVICENAME Service Worker

### General

* Description: YOURSERVICENAME Service worker terraform module
* Created By: YOURNAMEGOESHERE
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-YOURSERVICENAME-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-YOURSERVICENAME-worker/badge.svg)


### Usage

* Terraform (worker module deployment):

```hcl
module "YOURSERVICENAME_worker" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/YOURSERVICENAME/worker?ref=cn-YOURSERVICENAME-worker-v2.0.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
  vpc_name = var.vpc_name
}
```


### Initialization


### Terraform

* Run the YOURSERVICENAME service worker module in `YOURSERVICENAME/base` folder
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
            ├── worker
            │   ├── env_global.tf -> ../../../../env_global.tf
            │   ├── YOURSERVICENAME_worker.tf
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
