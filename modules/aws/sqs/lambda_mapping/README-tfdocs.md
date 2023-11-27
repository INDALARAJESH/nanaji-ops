<!-- BEGIN_TF_DOCS -->
# SNS SQS Subscription

### General

* Description: A module to create a SQS-2-lambda mapping
* Created By: Warren Nisley
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-sqs-lambda_mapping](https://github.com/ChowNow/ops-tf-modules/workflows/aws-sqs-lambda_mapping/badge.svg)

## Usage

* Terraform:

```hcl
# Recommended: passing arn directly
module "sqs_lambda_mapping" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/lambda_mapping?ref=aws-sqs-lambda_mapping-v2.2.0"
  env                  = "environment"
  env_inst             = "environment instance"
  service              = "service name"
  lambda_iam_role_id   = "lambda iam role id"
  mapping_batch_size   = "sqs batch size"
  sqs_queue_name       = "sqs queue name"
  lambda_function_arn = "lambda function arn"
  maximum_batching_window_in_seconds = "max wait seconds to assemble batch"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| function\_response\_types | A list of current response type enums applied to the event source mapping for AWS Lambda checkpointing | `list` | `[]` | no |
| lambda\_function\_arn | arn of recipient lambda function | `any` | n/a | yes |
| lambda\_iam\_role\_id | id of lambda iam role | `any` | n/a | yes |
| mapping\_batch\_size | size of message batch to pass to lambda | `number` | `10` | no |
| maximum\_batching\_window\_in\_seconds | max wait seconds to assemble batch | `number` | `5` | no |
| maximum\_concurrency | Limits the number of concurrent instances that the event source can invoke. Must be between 2 and 1000 | `any` | `null` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| sqs\_queue\_name | name of sqs queue. You must pass in the sqs\_queue\_name output from sqs module | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->