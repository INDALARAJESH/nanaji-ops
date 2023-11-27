<!-- BEGIN_TF_DOCS -->
# Terraform Lambda Module - Basic

## General

* Description: Basic Lambda Module
* Created By: Tim Ho, Karol Kania
* Terraform Version: 0.14.x

![aws-lambda-basic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-lambda-basic/badge.svg)

## Usage

* Terraform:

```hcl
/*
  Basic reference:
*/
module "randomjob1" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.1.1"

  env                   = var.env
  lambda_description    = "sample description for new lambda"
  lambda_classification = "randomjob1_${var.env}"
  service               = "joetest"
}

/*
  A more custom reference with customized threshold and lambda run frequency variables:
*/
module "randomjob2" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.1.1"

  env                 = var.env
  lambda_cron_boolean = false
  lambda_description  = "sample description for new lambda"
  lambda_name         = "randomjob1"
  lev_slack_channel   = "ABCDEFG"
  service             = var.service
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name                               | Description                                                                                         | Type           | Default                        | Required |
| ---------------------------------- | --------------------------------------------------------------------------------------------------- | -------------- | ------------------------------ | :------: |
| bucket\_prefix                     | prefix for s3 bucket name                                                                           | `string`       | `"cn-"`                        |    no    |
| cloudwatch\_logs\_retention        | CloudWatch logs retention in days                                                                   | `number`       | `14`                           |    no    |
| cloudwatch\_schedule\_expression   | schedule in cron notation to run lambda                                                             | `string`       | `"cron(0 10 * * ? *)"`         |    no    |
| domain                             | domain to use for lambda                                                                            | `string`       | `""`                           |    no    |
| env                                | environment                                                                                         | `any`          | n/a                            |   yes    |
| env\_inst                          | environment instance name                                                                           | `string`       | `""`                           |    no    |
| extra\_tags                        | optional addition for tags                                                                          | `map`          | `{}`                           |    no    |
| first\_lambda\_zip\_key            | location of first dummy lambda zip                                                                  | `string`       | `"version/initial/lambda.zip"` |    no    |
| lambda\_autoscaling                | Whether to enable Application AutoScaling - operates on Provisioned concurrency                     | `bool`         | `false`                        |    no    |
| lambda\_autoscaling\_max\_capacity | The max capacity of the scalable target                                                             | `number`       | `5`                            |    no    |
| lambda\_autoscaling\_min\_capacity | The min capacity of the scalable target                                                             | `number`       | `1`                            |    no    |
| lambda\_classification             | unique full name for lambda                                                                         | `string`       | `""`                           |    no    |
| lambda\_cron\_boolean              | enables or disables cloudwatch cron creation                                                        | `bool`         | `true`                         |    no    |
| lambda\_description                | description of lambda's purpose                                                                     | `string`       | `""`                           |    no    |
| lambda\_ecr                        | use ECR for lambda code                                                                             | `bool`         | `false`                        |    no    |
| lambda\_env\_variables             | Lambda environment variables map                                                                    | `map(string)`  | `{}`                           |    no    |
| lambda\_handler                    | Lambda handler                                                                                      | `string`       | `"app.lambda_handler"`         |    no    |
| lambda\_image\_config\_cmd         | Parameters that you want to pass in with `entry_point`.                                             | `string`       | `""`                           |    no    |
| lambda\_image\_uri                 | lambda ECR image URI                                                                                | `string`       | `""`                           |    no    |
| lambda\_layer\_names               | list of lambda layer names                                                                          | `list(string)` | `[]`                           |    no    |
| lambda\_memory\_size               | lambda memory size                                                                                  | `number`       | `128`                          |    no    |
| lambda\_name                       | unique name for lambda                                                                              | `string`       | `"CHANGETHELAMBDANAME"`        |    no    |
| lambda\_optional\_policy\_arn      | ARN of optional IAM policy to be attached to the role used by this Lambda                           | `string`       | `""`                           |    no    |
| lambda\_optional\_policy\_enabled  | Whether to pass additional IAM policy to be attached to lambda's role                               | `bool`         | `false`                        |    no    |
| lambda\_provisioned\_concurrency   | Manages a Lambda Provisioned Concurrency Configuration                                              | `number`       | `0`                            |    no    |
| lambda\_publish                    | Whether to publish creation/change as new Lambda Function Version AND Alias `:newest`               | `bool`         | `false`                        |    no    |
| lambda\_runtime                    | Lambda runtime                                                                                      | `string`       | `"python3.7"`                  |    no    |
| lambda\_s3                         | use S3 for lambda code                                                                              | `bool`         | `true`                         |    no    |
| lambda\_tag\_managed\_by           | tag to differentiate terraform managed lambda functions from non-terraform managed lambda functions | `string`       | `"terraform"`                  |    no    |
| lambda\_timeout                    | Lambda timeout                                                                                      | `string`       | `"300"`                        |    no    |
| lambda\_tracing\_enabled           | Whether to to sample and trace a subset of incoming requests with AWS X-Ray                         | `bool`         | `false`                        |    no    |
| lambda\_vpc\_sg\_ids               | List of security group IDs associated with the Lambda function.                                     | `list`         | `[]`                           |    no    |
| lambda\_vpc\_subnet\_ids           | List of subnet IDs associated with the Lambda function.                                             | `list`         | `[]`                           |    no    |
| lev\_debug                         | debug flag for lambda                                                                               | `string`       | `"false"`                      |    no    |
| lev\_slack\_channel                | which slack channel to send alerts                                                                  | `string`       | `"GHYR4NVN2"`                  |    no    |
| lev\_slack\_webhook                | webhook to use to send slack alert                                                                  | `string`       | `""`                           |    no    |
| s3\_acl                            | acl type for s3 bucket                                                                              | `string`       | `"private"`                    |    no    |
| s3\_sse\_algorithm                 | encryption algorithm used for s3 bucket                                                             | `string`       | `"AES256"`                     |    no    |
| service                            | unique service name                                                                                 | `any`          | n/a                            |   yes    |
| tag\_managed\_by                   | what created resource to keep track of non-IaC modifications                                        | `string`       | `"Terraform"`                  |    no    |

## Outputs

| Name                                         | Description                                                                                                                                                                          |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| aws\_cloudwatch\_log\_group\_name            | lambda function cloudwatch log\_group name                                                                                                                                           |
| lambda\_base\_name                           | Lambda function base name                                                                                                                                                            |
| lambda\_bucket\_name                         | Lambda artifact/zip storage bucket                                                                                                                                                   |
| lambda\_function\_arn                        | Lambda function arn                                                                                                                                                                  |
| lambda\_function\_arn\_alias\_newest         | Lambda function alias arn                                                                                                                                                            |
| lambda\_function\_invoke\_arn                | Lambda function invoke arn                                                                                                                                                           |
| lambda\_function\_invoke\_arn\_alias\_newest | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws\_api\_gateway\_integration's uri -- alias that points to the specified Lambda function version. |
| lambda\_function\_name                       | Lambda function name                                                                                                                                                                 |
| lambda\_iam\_role\_id                        | exposing lambda iam role id for iam attachment that use id                                                                                                                           |
| lambda\_iam\_role\_name                      | exposing lambda iam role to enable attaching custom policies                                                                                                                         |

## Lessons Learned

## References

* [Terraform does not need your code to provision a lambda function](https://amido.com/blog/terraform-does-not-need-your-code-to-provision-a-lambda-function/)
* [Serverless Application with AWS Lambda and API Gateway](https://learn.hashicorp.com/terraform/aws/lambda-api-gateway)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
