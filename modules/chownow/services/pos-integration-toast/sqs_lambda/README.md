<!-- BEGIN_TF_DOCS -->
# Toast POS Service SQS + Lambda Module

### General

* Description: A sub-module to POS toast integration service
* Created By: Abdulwahid Barguzar, and Kareem Shahin
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

The goal is to implement a reusable module with SQS + Lambda combination, which integrates with different components of POS Integration toast service such as partner & menu sync handler. This module is designed with a flow where SQS queue will be consuming message received and trigger the lambda to process the message in async manner.

To attach additional policies to the lambda, you must utilize the `aws_iam_role_policy_attachment` resource and provide a policy arn and attach it to the lambda's role which is an output of the module (see below).

## Usage

* Terraform:

```hcl
module "partner" {
  source                   = "./sqs_lambda"
  service                  = local.service
  env                      = local.env
  sqs_queue_name           = "partner"
  fifo_queue               = true
  handler_name             = "partner"
  handler_lambda_image_tag = var.lambda_image_tag
  lambda_base_policy_arn   = aws_iam_policy.lambda_base.arn
  image_repository_url     = local.image_repository_url

  environment_variables = merge(
    {
      DYNAMODB_TABLE    = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL      = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER = var.webhook_partner_lambda_command
      GSI_1_NAME        = local.db_cn_restaurant_gsi_name
    },
    local.datadog_env_vars
  )
}


resource "aws_iam_role_policy_attachment" "partner_policy_attachment_dynamo_read" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_role_policy_attachment" "partner_policy_attachment_dynamo_write" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_write.arn
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_logs\_retention | CloudWatch logs retention in days | `number` | `14` | no |
| delay\_seconds | delay seconds | `number` | `0` | no |
| env | Env name | `any` | n/a | yes |
| environment\_variables | map of environment variables for the lambda function | `map(string)` | `{}` | no |
| fifo\_queue | true to create a fifo queue | `bool` | `false` | no |
| handler\_lambda\_image\_tag | Handler lambda image tag. | `any` | n/a | yes |
| handler\_name | Handler name | `any` | n/a | yes |
| image\_repository\_url | Image repository url | `any` | n/a | yes |
| lambda\_base\_policy\_arn | Base AWS IAM policy arn for all service lambdas | `any` | n/a | yes |
| lambda\_memory\_size | amount of memory in MB for lambda function | `number` | `128` | no |
| lambda\_security\_group\_ids | Security group ids for the lambda function | `list` | `[]` | no |
| lambda\_timeout | amount of time lambda function has to run in seconds | `number` | `10` | no |
| lambda\_vpc\_subnet\_ids | VPC subnet ids where the lambda function can be executed | `list(string)` | `[]` | no |
| mapping\_batch\_size | SQS mapping batch size | `number` | `10` | no |
| max\_message\_size | max message size | `number` | `262144` | no |
| max\_receive\_count | number of times a message is delivered to queue before sending to dlq | `number` | `2` | no |
| message\_retention\_seconds | message retention seconds | `number` | `345600` | no |
| receive\_wait\_time\_seconds | receive wait time seconds | `number` | `20` | no |
| service | Service name | `any` | n/a | yes |
| sqs\_queue\_name | name of sqs queue | `any` | n/a | yes |
| visibility\_timeout\_seconds | visibility timeout in seconds - AWS recommends this to be at least 6x the lambda function timeout value | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| dlq\_queue\_arn | the arn of the handler's DLQ queue |
| dlq\_queue\_name | the name of the handler's DLQ queue |
| lambda\_handler\_arn | the arn of the lambda handler |
| lambda\_handler\_name | the name of the lambda handler |
| lambda\_handler\_role\_arn | the arn of the lambda handler's role |
| lambda\_handler\_role\_name | the name of the lambda handler's role |
| queue\_arn | the arn of the handler's SQS queue |
| queue\_name | the name of the handler's SQS queue |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->