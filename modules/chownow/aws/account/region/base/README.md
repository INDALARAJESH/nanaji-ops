# AWS Region Base

### General

* Description: A module to create resources that need to be created in every region:
  * ec2 key pair
  * sns topic
  * slack webhook secret
  * svpn wildcard certificate
  * chownowapi wildcard cert
* Created By: Joe Perez
* Module Dependencies:
  * `aws-global-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-region-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-region-base/badge.svg)

### Usage

* Terraform:

`ops>terraform>environments`
```
env
├── global
│   └── base
└── us-east-1
    └── base
        ├── base.tf
        ├── provider.tf
        └── variables.tf
```

* Region base example

`base.tf`
```hcl
module "useast1_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/region/base?ref=cn-aws-region-base-v2.1.4"

  env = "ncp"

}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name               | Description                                                        | Options             |  Type  | Required? | Notes |
| :-------------------------- | :----------------------------------------------------------------- | :------------------ | :----: | :-------: | :---- |
| enable_cert_wildcard        | enable/disable creation of wildcard cert for public zone           | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| enable_cert_chownowapi      | enable/disable creation of wildcard cert for chownowapi zone       | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| enable_cert_chownowcdn      | enable/disable creation of wildcard cert for chownowcdn zone       | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| enable_key_pair             | enable/disable creation of ec2 key pair                            | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| enable_kms_key              | enable/disable creation of kms key                                 | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| enable_publish_from_sns     | enable/disable creation of sns publishing                          | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| enable_secret_slack_webhook | enable/disable creation of slack webhook secret in secrets manager | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| build_dns_zone_name         | enable/disable build dns zone name from env and domain variables   | 0 or 1 (default: 1) |  int   |    No     | N/A   |
| env                         | unique environment/stage name                                      |                     | string |    Yes    | N/A   |
| env_inst                    | environment instance number                                        | 1...n               | string |    No     | N/A   |
| service_user                | service user override                                              |                     | string |    No     | N/A   |
#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned


### References
