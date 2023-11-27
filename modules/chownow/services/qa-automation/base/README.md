# ChowNow QA Automation Module

### General

* Description: A module to create resources needed for QA automation tasks
* Created By: Jobin Muthalaly
* Module Dependencies:
  * existing `iam` module
  * existing `s3` module
* Provider Dependencies: `aws`
* Terraform Version: 0.14.7

![chownow-services-qa-automation](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-qa-automation/badge.svg)


### Usage

* Terraform (basic):


`qa_automation_base.tf`
```hcl
module "qa_automation_base" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/qa-automation/base?ref=qa-automation-base-v2.0.0"
  env             = var.env
}
```


## Module Options


### Inputs

| Variable Name     | Description                                 | Options             |  Type   | Required? | Notes |
| ----------------- | ------------------------------------------- | ------------------- | ------- | --------- | ----- |
| env               | environment/stage                           | uat, qa, stg, prod  | String  | Yes       | N/A   |
| env_inst          | environment instance, eg 01 added to stg01  | 00, 01, 02, etc     | String  | No        | N/A   |




### Outputs

| Variable Name     | Description                                     | Type    | Notes |
| ----------------- | ---------------------------------------------   | ------- | ----- |



### Lessons Learned


### Resources
