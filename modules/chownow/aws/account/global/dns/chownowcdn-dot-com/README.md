# chownowcdn.com DNS Records

### General

* Description: A place to put new dns records that are not associated with a specific service
* Created By: Allen Dantes
* Module Dependencies:
  * existing `chownowcdn.com` DNS zone
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-global-dns-chownowcdn-dot-com](https://github.com/ChowNow/ops-tf-modules/workflows/cn-global-dns-chownowcdn-dot-com/badge.svg)


### Usage

* Terraform (basic):


`chownowcdn-dot-com.tf`
```hcl
module "chownowcdn-dot-com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/global/dns/chownowcdn-dot-com?ref=cn-global-dns-chownowcdn-dot-com-v2.0.2"

  env                 = var.env
  delegate_account_id = "123"
}

provider "aws" {
  alias = "delegate"
  assume_role {
    role_arn     = "arn:aws:iam::731031120404:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}
```


## Module Options


### Inputs

| Variable Name       | Description                                | Options            | Type   | Required? | Notes |
| ------------------- | ------------------------------------------ | ------------------ | ------ | --------- | ----- |
| env                 | environment/stage                          | uat, qa, stg, prod | String | Yes       | N/A   |
| env_inst            | environment instance, eg 01 added to stg01 | 00, 01, 02, etc    | String | No        | N/A   |
| delegate_account_id | accoutn id of delegated zone               |                    | String | No        | N/A   |



### Outputs

| Variable Name | Description | Type | Notes |
| ------------- | ----------- | ---- | ----- |



### Lessons Learned


### Resources
