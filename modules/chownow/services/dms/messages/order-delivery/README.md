# Managed Delivery Service Messages Order Delivery Module

### General

* Description: Terraform module for the Managed Delivery Service order delivery events SNS topic
* Created By: Mike Tsui
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-dms-messages-order-delivery](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-dms-messages-order-delivery/badge.svg)


### Usage

* Terraform:

```hcl
module "dms_messages_order_delivery" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dms/messages/order-delivery?ref=dms-messages-order-delivery-v2.0.1"

  env = var.env
}
```


### Initialization


### Terraform

* Example directory and terraform workspace structure:

`ops/terraform/environments/ENV`
```
├── env_global.tf
├── global
└── us-east-1
    └── services
        └── dms
            └── messages
                └── order-delivery
                    ├── env_global.tf -> ../../../../../env_global.tf
                    ├── main.tf
                    └── provider.tf
```

### Inputs

| Variable Name                           | Description                                | Options                       | Type    | Required? | Notes |
| --------------------------------------- | ------------------------------------------ | ----------------------------- | ------- | --------- | ----- |
| env                                     | environment/stage                          | dev, qa, stg, uat, prod       | String  | Yes       | N/A   |
| env_inst                                | environment instance                       | 00, 01, 02, 03                | String  | No        | N/A   |
| sns_lambda_success_feedback_sample_rate | SNS lambda success feedback sample rate    | (default: 100)                | Int     | No        | N/A   |
| sns_cross_account_access_arn            | ARN to allow topic subscription            |                               | String  | No        | N/A   |


### Outputs

| Variable Name | Description | Type | Notes |
| ------------- | ----------- | ---- | ----- |


### Lessons Learned


### Resources
