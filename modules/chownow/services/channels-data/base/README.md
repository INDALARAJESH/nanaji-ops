# Channels Data Service Base

### General

* Description: Channels Data Service base terraform module.
  This module creates resources used by the service.
* Created By: Wesley Jin
* Module Dependencies:
  * AWS Provider 3.38+ (assumes `default_tags` support)
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-channels-data-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-channels-data-base/badge.svg)

  ### Usage, Latest Version

* Terraform:

```hcl
module "channels_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/channels-data/base?ref=cn-channels-data-base-v2.5.6"

  env      = var.env
  service  = var.service
}
```

2.5.4: add ddb credentials to SM  
2.5.5: added Google PALs/Starter secret.

### Initialization

### Terraform

* Example directory structure:
`ops/terraform/environments/dev`
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── channels-data
            ├── app
            │   ├── env_global.tf -> ../../../../env_global.tf
            │   ├── channels_app.tf
            │   └── provider.tf
            └── base
                ├── env_global.tf -> ../../../../env_global.tf
                ├── channels_base.tf
                └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                    | Description                         | Options                   |  Type  | Required? | Notes |
| :------------------------------- | :---------------------------------- | :------------------------ | :----: | :-------: | :---- |
| channels_data_s3_bucket_name     | name of channels bucket             | chownow-channels-data-env | string |    No     | N/A   |
| channels_data_s3_aws_account_ids | AWS accounts that have access to S3 | list(string)              |  List  |    No     | N/A   |
| env                              | unique environment/stage name       | dev/qa/prod/stg/uat/data  | string |    Yes    | N/A   |
| env_inst                         | iteration of environment            | eg 00,01,02,etc           | string |    No     | N/A   |
| service                          | service name                        | channels-data             | string |    No     | N/A   |




#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References

* [RFC: Channels Data Feed Service](https://chownow.atlassian.net/wiki/spaces/CE/pages/2482176133/RFC+Channels+Data+Feed+Service)
