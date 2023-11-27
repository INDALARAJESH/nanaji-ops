# Terraform Developer IAM

### General

* Description: IAM module to create necessary resources for terraform developer role assumed by developers
* Created By: Sebastien Plisson
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-terraform-developer-iam](https://github.com/ChowNow/ops-tf-modules/workflows/aws-terraform-developer-iam/badge.svg)


### Usage

* Terraform (basic):


`terraform_developer_iam.tf`
```hcl
module "terraform_developer_iam" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/terraform-developer/iam?ref=aws-terraform-developer-iam-v2.0.1"

  env                 = var.env

}
```


## Module Options


### Inputs

| Variable Name | Description                                | Options                        | Type   | Required? | Notes |
| ------------- | ------------------------------------------ | ------------------------------ | ------ | --------- | ----- |
| env           | environment/stage                          | uat, qa, stg, prod             | String | Yes       | N/A   |
| env_inst      | environment instance, eg 01 added to stg01 | 00, 01, 02, etc                | String | No        | N/A   |
| service       | unique service name                        | (default: terraform-developer) | String | Yes       | N/A   |



### Outputs

| Variable Name | Description | Type | Notes |
| ------------- | ----------- | ---- | ----- |


### Resources

### Learning
