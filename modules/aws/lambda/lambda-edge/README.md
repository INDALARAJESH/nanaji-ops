# Terraform Lambda Module - Edge
* Created By: Harry Hahn (from Lambda Basic)

![aws-lambda-edge](https://github.com/ChowNow/ops-tf-modules/workflows/aws-lambda-edge/badge.svg)

## General

This addresses some different requirements that lambda@edge has compared to "regular" lambda:
  * Role needs sts:AssumeRole for edgelambda.amazonaws.com (in addition to lambda.amazonaws.com)
  * Lambda must not have any environment variables defined (Cloudfront attachment fails if any exist)
  * Timeout must be under 30s for origin request/response, 5s for viewer

Furthermore, the one-lambda-one-bucket of lambda-basic was changed in favor of using the centralized cn-ENV-repo bucket for the s3 artifact.

Some naming conventions were simplified.

#### Terraform

* Basic reference:

```
module "edgelambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-edge?ref=aws-lambda-edge-v2.0.1"

  env                   = var.env
  lambda_description    = "sample description for new lambda"
  lambda_name           = "edgelambda"                          # Advise keeping lambda_name and service
  service               = "edgelambda"                          # the same.
}

```

### Resources

* [Requirements and Restrictions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-requirements-limits.html)
