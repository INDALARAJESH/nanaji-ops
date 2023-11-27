# S3 Access Logs

### General

* Description: Modules that creates s3 access logs bucket
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws 4.0`

![aws-s3-access-logs](https://github.com/ChowNow/ops-tf-modules/workflows/aws-s3-access-logs/badge.svg)

### Usage

* Terraform:

* S3 access logs
```hcl
module "s3_access_logs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/access-logs?ref=s3-access-logs-v2.0.1"

  env = var.env
}
```


bucket retrieval for using as a log destination:

```hcl

### data_source.tf
data "aws_s3_bucket" "s3_access_logs" {
  bucket = "cn-s3-access-logs-${var.env}"
}

### s3.tf
resource "aws_s3_bucket" "cn_super_important_bucket" {
  bucket = "cn-super-important-bucket-${var.env}"

}

resource "aws_s3_bucket_logging" "cn_super_important_bucket" {
  bucket = "cn-super-important-bucket-${var.env}"

  target_bucket = data.aws_s3_bucket.s3_access_logs.id
  target_prefix = "cn-super-important-bucket-${var.env}/"
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                           | Options                        | Type   | Required? | Notes |
| :------------ | :------------------------------------ | :----------------------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name         | dev, ncp, qa, stg, prod, etc   | string |  Yes      | N/A   |
| name_prefix   | bucket name prefix                    | default:cn                     | string |  No       | N/A   |
| sse_algorithm | bucket encryption algorithm           | default:AES256                 | string |  No       | N/A   |

#### Outputs

| Variable Name     | Description                                     | Type    | Notes |
| :---------------- | :--------------------------------------------   | :-----: | :---- |
| bucket_id         | s3 access log bucket ID                         | string  | N/A   |
| bucket_arn        | s3 access log bucket ARN                        | string  | N/A   |

### Lessons Learned



### References
