# EC2 Reboot Base Module

### General

* Description: Creates resources for ec2 reboot script to allow process to be self-service
* Created By: Joe Perez
* Module Dependencies:
  * `N/A`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-tools-ec2-reboot](https://github.com/ChowNow/ops-tf-modules/workflows/cn-tools-ec2-reboot/badge.svg)

### Usage

* Terraform (basic):

```
module "ec2_reboot_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/ops/tools/ec2-reboot/base?ref=cn-tools-ec2-reboot-v2.0.0"

  env = var.env
}
```

### Create Access Key for User

* create access key: `aws-vault exec ENV -- aws iam create-access-key --user svc_ec2-reboot-ENV`
* Put access/secret key in environment's 1Password Vault
* Add keys to Jenkins

## Module Options


### Inputs

| Variable Name       | Description                                | Options                            |  Type   | Required? | Notes        |
| ------------------- | ------------------------------------------ | ---------------------------------- | ------- | --------- | ------------ |
| env                 | environment/stage                          | uat, qa, qa00, stg, prod           | string  | Yes       | N/A          |
| service             | name for this ec2-reboot service           | ec2-reboot or something else       | string  | No        | N/A          |



### Outputs

| Variable Name     | Description                                     | Type    | Notes |
| ----------------- | ---------------------------------------------   | ------- | ----- |



### Lessons Learned

* Tried to adjust the resource to `us-east-1` based instances, but the `ec2-reboot` script kept throwing an auth error

### Resources
