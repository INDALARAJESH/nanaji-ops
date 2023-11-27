# errbot App

### General

* Description: Errbot app terraform module. This module creates Errbot's ECS service
* Created By: Allen Dantes
* Module Dependencies:
* Providers : `aws 5.0`, `random`

### Usage

* Terraform:

```hcl
module "errbot_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/errbot/app?ref=cn-errbot-app-v2.0.2"

  env           = "sb"
  image_version = "some-container-tag-goes-here"
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                         |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :------------------------------ | :----: | :-------: | :---- |
| env           | unique environment/stage name | sandbox/dev/qa/uat/stg/prod/etc | string |    Yes    | N/A   |
| image_version | Errbot container image tag    | SHA/feature branch              | string |    Yes    | N/A   |
#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### References

* [Errbot App](https://github.com/ChowNow/ops-serverless/tree/master/errbot)
