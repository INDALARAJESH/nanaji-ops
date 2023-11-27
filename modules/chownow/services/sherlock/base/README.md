# sherlock Base

### General

* Description: Sherlock base terraform module. This module creates secrets and other resources before the database and application
* Created By: Allen Dantes
* Module Dependencies:
* Providers : `aws`, `random`

### Usage

* Terraform:

```hcl
module "sherlock" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//chownow/services/sherlock/base?ref=sherlock-base-v1.0.0"

  env    = "sb"
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                            | Options                         | Type     | Required? | Notes |
| :------------------------- | :------------------------------------- | :------------------------------ | :------: | :-------: | :---- |
| env                        | unique environment/stage name          | sandbox/dev/qa/uat/stg/prod/etc | string   |  Yes      | N/A   |
#### Outputs

| Variable Name      | Description         | Type    | Notes |
| :----------------- | :------------------ | :-----: | :---- |


### Lessons Learned


### References
