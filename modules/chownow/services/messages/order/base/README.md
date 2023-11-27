# Messages - Order Base Module

### General

* Description: The terraform module to create the order events sns flow
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-messages-order-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-messages-order-base/badge.svg)


### Usage

* Terraform (base module deployment):


`order_base.tf`
```hcl
module "order_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/messages/order/base?ref=cn-messages-order-base-v2.0.0"

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
        └── messages
            └── order
                └── base
                    ├── env_global.tf -> ../../../../env_global.tf
                    ├── order_base.tf
                    └── provider.tf
```


## Module Options


### Inputs

| Variable Name                           | Description                                | Options                       | Type    | Required? | Notes |
| --------------------------------------- | ------------------------------------------ | ----------------------------- | ------- | --------- | ----- |
| enable_sns_fifo_topic                   | enables/disables fifo option on topic      | true or false (default: true) | Boolean | No        | N/A   |
| env                                     | environment/stage                          | uat, qa, stg, prod            | String  | Yes       | N/A   |
| env_inst                                | environment instance, eg 01 added to stg01 | 00, 01, 02, etc               | String  | No        | N/A   |
| service                                 | unique service name                        | (default: krv)                | String  | No        | N/A   |
| sns_lambda_success_feedback_sample_rate | SNS lambda success feedback sample rate    | (default: 100)                | Int     | No        | N/A   |



### Outputs

| Variable Name | Description | Type | Notes |
| ------------- | ----------- | ---- | ----- |



### Lessons Learned


### Resources
