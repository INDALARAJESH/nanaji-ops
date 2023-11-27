# chowqa.com DNS Records

### General

* Description: Zone and record creation for `chowqa.com`
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws 5.x`
* Terraform Version: `1.5.x`

![cn-global-dns-chowqa-dot-com](https://github.com/ChowNow/ops-tf-modules/workflows/cn-global-dns-chowqa-dot-com/badge.svg)


### Usage

* Terraform:


`chowqa-dot-com.tf`
```hcl
module "chowqa-dot-com" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/global/dns/chowqa-dot-com?ref=cn-global-dns-chowqa-dot-com-v3.0.0"

  env = var.env

  dns_records = var.dns_records
}

```


## Module Options


### Inputs

| Variable Name | Description                                | Options            | Type   | Required? | Notes |
| ------------- | ------------------------------------------ | ------------------ | ------ | --------- | ----- |
| dns_records   | list of DNS records to create              |                    | list   | Yes       | N/A   |
| env           | environment/stage                          | uat, qa, stg, prod | String | Yes       | N/A   |
| env_inst      | environment instance, eg 01 added to stg01 | 00, 01, 02, etc    | String | No        | N/A   |




### Outputs

| Variable Name | Description                  | Type | Notes |
| ------------- | ---------------------------- | ---- | ----- |
| nameservers   | list of nameservers for zone | list | N/A   |



### Lessons Learned


### Resources
