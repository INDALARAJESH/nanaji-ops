# S3 Module - Basic

### General

* Description: Terraform S3 Basic Module
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 1.5.x

![aws-s3-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-s3-base/badge.svg)

### Usage

* Terraform (private):

```hcl

module "cn_hermosa_private" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v3.0.0"

  count = var.enable_bucket_private

  bucket_name   = local.bucket_private
  env           = var.env
  env_inst      = var.env_inst
  service       = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}

```

* Terraform (private w/ CORS and lifecycle):

```hcl

module "cn_hermosa_merchant" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v3.0.0"

  count = var.enable_bucket_merchant

  acl           = "private"
  bucket_name   = local.bucket_merchant
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST"]
      allowed_origins = ["https://${local.env}.${var.svpn_subdomain}.${var.domain}"]
      expose_headers  = ["ETag", "x-amz-meta-custom-header"]
    },
    {
      allowed_headers = ["*"]
      allowed_methods = ["POST"]
      allowed_origins = ["https://admin.${local.env}.${var.svpn_subdomain}.${var.domain}"]
      expose_headers  = ["ETag", "x-amz-meta-custom-header"]
    },
  ]

  lifecycle_rule = [
    {
      abort_incomplete_multipart_upload_days = 7
      enabled                                = true
      id                                     = local.bucket_merchant
    }
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}

```

* Terraform (public with attached policy) :

```hcl

module "cn_hermosa_facebook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v3.0.0"

  count = var.enable_bucket_facebook

  acl           = "public-read"
  bucket_name   = local.bucket_facebook
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = true
  service       = var.service

  attach_public_policy = false
  policy               = templatefile("${path.module}/templates/s3/legacy_allow.json.tpl", { bucket_name = local.bucket_facebook })

}
```


* Terraform (ALB Log bucket):

```hcl
module "cn_alb_logs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v3.0.0"

  count = var.enable_bucket_alb_logs

  acl                           = "log-delivery-write"
  attach_lb_log_delivery_policy = true
  bucket_name                   = "cn-alb-logs-${local.env}"
  env                           = var.env
  env_inst                      = var.env_inst
  force_destroy                 = true
  service                       = "logging"

  attach_public_policy = false

  lifecycle_rule = [
    {
      enabled                                = true
      id                                     = "cn-alb-logs-${local.env}"
      prefix                                 = "log/"

      tags = {
        rule      = "log"
        autoclean = "true"
      }

      transition = [
        {
          days          = 93
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = 366
      }
    },
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}
```

## Module Options


### Inputs

| Variable Name                 | Description                                   | Options                                            | Type    | Required? | Notes |
| ----------------------------- | --------------------------------------------- | -------------------------------------------------- | ------- | --------- | ----- |
| attach_lb_log_delivery_policy | attaches lb log delivery policy to s3 bucket  | true/false (default: false)                        | boolean | No        | N/A   |
| attach_public_policy          | attaches public block policy                  | true/false (default: true)                         | boolean | No        | N/A   |
| bucket_name                   | bucket prefix used to create bucket name      | eg. example-bucket                                 | string  | Yes       | N/A   |
| acl                           | bucket canned acl                             | any aws supported canned acls (default: `private`) | string  | No        | N/A   |
| env                           | environment/stage                             | uat, qa, stg, ncp, prod                            | string  | Yes       | N/A   |
| env_inst                      | environment instance number                   | 00, 01, 02, etc                                    | string  | No        | N/A   |
| extra_tags                    | optional addition for tags                    | mapping of key-value pairs                         | map     | No        | N/A   |
| force_destroy                 | enables the ability to force destroy a bucket | true or false (defaults to false)                  | boolean | No        | N/A   |
| policy                        | rendered json IAM policy for bucket           | rendered template file or inline policy            | string  | No        | N/A   |
| service                       | service name for project/application          | eg hermosa, dms                                    | string  | Yes       | N/A   |
| tag_managed_by                | managed by tag                                | name (default: Terraform)                          | string  | No        | N/A   |


### Outputs

| Variable Name | Description            | Type   | Notes |
| ------------- | ---------------------- | ------ | ----- |
| bucket_name   | the name of the bucket | string | N/A   |
| bucket_arn    | the arn of the bucket  | string | N/A   |


### Lessons Learned

* Conditionally created stanzas with `dynamic` are great for consolidating s3 modules, but the terraform code is harder to read AND use.


### Resources

* Heavily influenced by [terraform-aws-s3-bucket](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket)
* [Access Logging Bucket Permissions(https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions)
