# Hermosa Events Base

### General

* Description: Hermosa events base terraform module.
  This module creates resources used to deploy base resources needed for Hermosa events.
* Created By: Warren Nisley
* Module Dependencies:
* Module Components: `hermosa`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-hermosa-events-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-events-base/badge.svg)

### Usage

* Terraform:

```hcl
module "hermosa_events_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/events/base?ref=hermosa-events-base-v2.1.10"

  env                  = var.env
  env_inst             = var.env_inst
  lambda_image_version = var.lambda_image_version
  vpc_name_prefix      = var.vpc_name_prefix
  fifo_queue_enabled   = false
  sns_memberships_topic_arn = "ARN of the SNS topic to subscribe to"
  sns_order_delivery_topic_arn = "ARN of the SNS topic to subscribe to"
}
```



### Initialization

### Terraform

* Run the hermosa events base module in the `hermosa/events/base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── hermosa
          └── events
            └── base
                ├── data_sources.tf
                ├── iam.tf
                ├── logs.tf
                ├── secrets.tf
                ├── sns_subscription.tf
                ├── sns_variables.tf
                ├── sqs.tf
                ├── sqs_variables.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                             | Options/Defaults         |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat      | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg: 00,01,02,load        | string |    No     | N/A            |
| vpc_name_prefix               | vpc prefix                              | main                     | string |    Yes    | N/A            |
| app_name                      | shorter name used in some tagging       | hermosa                  | string |    No     | N/A            |
| fifo_queue_enabled            | is the queue FIFO enabled?              | True                     | bool   |    No     | N/A            |
| service                       | name of this lambda                     | hermosa-lambda           | string |    No     | N/A            |
| sqs_queue_name                | sqs queue name to subscribe to          | hermosa-events           | string |    No     | N/A            |
| sns_memberships_topic_name    | membership sns topic name               | cn-membership-events     | string |    No     | N/A            |
| sns_memberships_topic_arn     | arn of membership sns topic             | cn-membership-events     | string |    No     | N/A            |
| sns_order_delivery_topic_arn  | arn of membership sns topic             | cn-order-delivery-events | string |    No     | N/A            |
| membership_updated_message_type_filter | membership message filter      | com.chownow.membership.updated | string |  No | N/A            |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References

* [Hermosa Event handlers - Confluence](https://chownow.atlassian.net/l/cp/NZUxPjVe)
