# Security Base

### General

* Description: Modules that creates cloudtrail and syslog resources for ChowNow
* Created By: Joe Perez
* Module Dependencies: `s3-access-logs`
* Provider Dependencies: `aws`

### Usage

* Terraform:

* S3 access logs
```hcl
module "security_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/security/base?ref=cn-security-base-v2.0.1"

  env = var.env
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                   | Options                      |  Type  | Required? | Notes |
| :------------------- | :---------------------------- | :--------------------------- | :----: | :-------: | :---- |
| env                  | unique environment/stage name | dev, ncp, qa, stg, prod, etc | string |    Yes    | N/A   |
| enable_cloudtrail_dd | enables/disables cloudtrail   | (default: 0)                 |  Int   |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

* Refactoring this code was harder than expected


### References

* [Create S3 bucket policy for cloudtrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html)
