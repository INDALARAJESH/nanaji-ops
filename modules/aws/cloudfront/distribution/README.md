### General

* Description: A module to create a cloudfront distribution
* Created By: Sebastien Plisson
* Module Dependencies: `None`

![aws-cloudfront-distribution](https://github.com/ChowNow/ops-tf-modules/workflows/aws-cloudfront-distribution/badge.svg)

### Usage

```hcl

module "cloudfront" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudfront/distribution?ref=aws-cloudfront-distribution-v2.0.1"
  env = var.env
  
  acm_certificate_arn =data.aws_acm_certificate.origin.arn
  bucket_domain_name = data.aws_s3_bucket.origin.bucket_domain_name
}

```

#### Inputs

| Variable Name               | Description          | Options                  | Type   | Required? | Notes |
| --------------------------- | -------------------- | ------------------------ | ------ | --------- | ----- |
| service                     | Name of service      | N/A                      | string | Yes       | N/A   |
| env                         | environment/stage    | uat, qa, qa00, stg, prod | string | Yes       | N/A   |
| env_inst                    | environment instance | 00, 01, 02               | string | No        | N/A   |
| acm_certificate_arn         |                      |                          | string | Yes       | N/A   |
| bucket_name                 |                      |                          | string | Yes       | N/A   |
| bucket_domain_name          |                      |                          | string | Yes       | N/A   |
| bucket_arn                  |                      |                          | string | Yes       | N/A   |
| name_prefix                 | prefix               | default: cn              | string | No        | N/A   |
| price_class                 |                      |                          | string | No        | N/A   |
| aliases                     | dns aliases          |                          | list   | No        | N/A   |
| viewer_protocol_policy      |                      | default: allow_all       | string | No        | N/A   |
| lambda_function_association |                      |                          | list   | No        | N/A   |
| custom_error_response       |                      |                          | list   | No        | N/A   |
| headers                     |                      |                          | list   | No        | N/A   |
| viewer_protocol_policy      |                      |                          | string | No        | N/A   |
| web_acl_id                  | AWS WAF web ACL ID.  |                          | string | No        | See Variable Definition |
#### Outputs

#### Notes
