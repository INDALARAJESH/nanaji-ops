# Errbot Base

### General

* Description: Errbot base terraform module. This module creates secrets and other resources before the database and application
* Created By: Allen Dantes
* Module Dependencies:
* Providers : `aws`, `random`

### Usage

* Terraform:

```hcl
module "errbot" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/errbot/base?ref=cn-errbot-base-v2.0.3"

  env = "sb"
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                         |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :------------------------------ | :----: | :-------: | :---- |
| env           | unique environment/stage name | sandbox/dev/qa/uat/stg/prod/etc | string |    Yes    | N/A   |
#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### References

* [Errbot App](https://github.com/ChowNow/ops-serverless/tree/master/errbot)
