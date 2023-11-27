# Packer IAM

### General

* Description: IAM module to create necessary resources for Packer build process
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-packer-iam](https://github.com/ChowNow/ops-tf-modules/workflows/aws-packer-iam/badge.svg)


### Usage

* Terraform (basic):


`packer_iam.tf`
```hcl
module "packer_iam" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/packer/iam?ref=aws-packer-iam-v2.0.0"

  env                 = var.env

}
```


## Module Options


### Inputs

| Variable Name               | Description                                 | Options                            | Type     | Required? | Notes |
| --------------------------- | ------------------------------------------- | ---------------------------------- | -------- | --------- | ----- |
| env                         | environment/stage                           | uat, qa, stg, prod                 | String   | Yes       | N/A   |
| env_inst                    | environment instance, eg 01 added to stg01  | 00, 01, 02, etc                    | String   | No        | N/A   |
| service                     | unique service name                         | (default: packer)                  | String   | Yes       | N/A   |



### Outputs

| Variable Name     | Description                                     | Type   | Notes |
| ----------------- | ----------------------------------------------- | ------ | ----- |


### Resources

### Learning
