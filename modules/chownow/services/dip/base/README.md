
# Developer Infrastructure Provisioning - Base

### General

* Description: This module creates the necessary resources to allow developers to get started with developing terraform in an AWS environment
* Created By: Joe Perez
* Module Dependencies:
* Module Components:
  * S3 Bucket
  * IAM User Service account
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-dip-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-dip-base/badge.svg)
### Usage

* Terraform:

```hcl
module "dip_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dip/base?ref=chownow-dip-base-v2.0.3"

  env = "dev"
}
```

#### Post Terraform steps

1. Create an AWS access key for the `dip` account: `aws-vault exec ENV -- aws iam create-access-key --user-name svc_dip-ENV`
    - _Note: replace `ENV` with the short environment name you're using_
2. Store the Access Key ID and Secret Access Key in the environment's 1PW Vault
3. Add Credentials to [Jenkins](https://jenkins.ops.svpn.chownow.com/credentials/store/system/) in the domain/environment with the name `svc_dip-ENV` (replacing `ENV` with the proper short environment name)
4. Add new environment to the the DIP [Jenkinsfile](https://github.com/ChowNow/ops/tree/master/Jenkinsfiles)
5. Test DIP Jenkins job with newly added environment
6. Notify developers about additional environment



### Initialization

### Terraform

* Run the dip base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── dip
            └── base
                ├── dip_base.tf
                ├── provider.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                             | Options                  |  Type  | Required? | Notes          |
| :------------ | :-------------------------------------- | :----------------------- | :----: | :-------: | :------------- |
| env           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| service       | service name                            | (default: dip)           | string |    No     | N/A            |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned




### References
* [Rotating secrets with terraform](https://cloud.gov/docs/ops/runbook/rotating-iam-users/)
