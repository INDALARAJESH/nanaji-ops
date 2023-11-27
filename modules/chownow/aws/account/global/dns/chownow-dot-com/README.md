# ChowNow.com DNS Records

### General

* Description: A place to put new dns records that are not associated with a specific service
* Created By: Joe and Jobin
* Module Dependencies:
  * existing `chownow.com` DNS zone
* Provider Dependencies: `aws`
* Terraform Version: 1.5.0

![cn-global-dns-chownow-dot-com](https://github.com/ChowNow/ops-tf-modules/workflows/cn-global-dns-chownow-dot-com/badge.svg)


### Usage

* Terraform (basic):


`chownow-dot-com.tf`
```hcl
module "chownow-dot-com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/accounts/global/dns/chownow-dot-com?ref=cn-global-dns-chownow-dot-com-v3.0.0"

  env                 = var.env

}
```

## Module Options

### Inputs

| Variable Name | Description                                | Options            | Type   | Required? | Notes |
| ------------- | ------------------------------------------ | ------------------ | ------ | --------- | ----- |
| env           | environment/stage                          | uat, qa, stg, prod | String | No        | N/A   |
| env_inst      | environment instance, eg 01 added to stg01 | 00, 01, 02, etc    | String | No        | N/A   |

### Outputs

| Variable Name | Description | Type | Notes |
| ------------- | ----------- | ---- | ----- |


### Lessons Learned


### Resources
