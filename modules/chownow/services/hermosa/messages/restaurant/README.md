# Hermosa Messages Restaurant Favorite Module

### General

* Description: Terraform module for the Hermosa restaurant favorite events SNS topic
* Created By: Serge Makovsky
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x


### Usage

* Terraform:

```hcl
module "hermosa_restaurant_favorite" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/messages/restaurant?ref=hermosa-messages-restaurant-favorite-v2.0.0"

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
        └── hermosa
            └── messages
                └── restaurant
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
