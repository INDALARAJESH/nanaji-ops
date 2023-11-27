# Lambda Deployment Module

### General

* Description: Creates S3 bucket and IAM Policy for lambda deployment
* Created By: Allen Dantes
* Module Dependencies:
* Provider Dependencies: `aws`

![cn-services-lambda-deploy](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-lambda-deploy/badge.svg)

### Usage

* Terraform:

```hcl
module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/deploy?ref=cn-lambda-deploy-v2.1.1"

  env           = var.env

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options             |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :------------------ | :----: | :-------: | :---- |
| service       | unique service name           | default: lambda     | string |    No     | N/A   |
| service_user  | service user                  |                     | string |    No     | N/A   |
| env           | unique environment/stage name | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst      | environment instance number   | 1...n               | string |    No     | N/A   |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |
