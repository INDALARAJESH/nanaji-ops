# Devscrub Base

### General

* Description: Devscrub app terraform module.
  This module creates resources used by the data-redaction app.
* Created By: Warren Nisley
* Module Dependencies:
* Module Components: `data-redaction-app`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-data-redaction-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-data-redaction-app/badge.svg)

### Usage

* Terraform:

```hcl
module "data_redaction_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/data-redaction/app?ref=data-redaction-app-v2.0.1"

  env           = "dev"
  service       = "data-redaction"
  image_version = "9ac79d5f1"
  app_name      = "hermosa"
  target_db     = "hermosa-mysql-dev"

  td_cpu    = 1024
  td_memory = 2048
}
```



### Initialization

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                               | Options                  |  Type  | Required | Default                                                     |
| :------------------- | :---------------------------------------- | :----------------------- | :----: | :------: | :---------------------------------------------------------- |
| env                  | environment/stage name                    | dev,qa,prod,stg,uat,data | string |    Y     |                                                             |
| env_inst             | iteration of environment                  | 00, 01, etc              | string |    N     |                                                             |
| service              | service name                              |                          | string |    Y     | data-redaction                                              |
| image_version        | docker image version of redaction service |                          | string |    Y     | latest                                                      |
| target_db            | target database to scrub                  |                          | string |    Y     |                                                             |
| cluster_prefix       | cluster name prefix                       |                          | string |    N     |                                                             |
| db_prefix            | database instance name prefix             |                          | string |    N     |                                                             |
| image_repository_arn | repository for docker image               |                          | string |    Y     | 449190145484.dkr.ecr.us-east-1.amazonaws.com/data-redaction |
| td_cpu               | cpu for ecs task                          | 256,512,1024,2048,4096   | string |    Y     | 256                                                         |
| td_memory            | memory for ecs task                       | 512-30720                | string |    Y     | 512                                                         |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### References
