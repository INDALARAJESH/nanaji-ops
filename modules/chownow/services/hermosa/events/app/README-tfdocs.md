<!-- BEGIN_TF_DOCS -->
# Hermosa Events App

### General

* Description: Hermosa events app terraform module.
  This module creates resources used to deploy Hermosa events app as a lambda.
* Created By: Warren Nisley
* Module Dependencies:
* Module Components: `hermosa`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-hermosa-events-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-events-app/badge.svg)

## Usage

* Terraform:

```hcl
module "hermosa_events_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/events/app?ref=hermosa-events-app-v2.2.7"
  env                  = var.env
  env_inst             = var.env_inst
  lambda_image_version = var.lambda_image_version
  vpc_name_prefix      = var.vpc_name_prefix
  fifo_queue_enabled   = false
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_name | app name | `string` | `"hermosa"` | no |
| dd\_enhanced\_metrics | Lambda environment var for `datadog-lambda` DD\_ENHANCED\_METRICS setting (may affect AWS bill when used with Datadog Forwarder via Cloudwatch logs; to opt-out set it to false) | `string` | `"true"` | no |
| dd\_flush\_to\_log | Lambda environment var for `datadog-lambda` DD\_FLUSH\_TO\_LOG setting | `string` | `"true"` | no |
| dd\_lambda\_handler | handler to invoke from datadog (set as DD\_LAMBDA\_HANDLER environment variable) | `string` | `"event_handlers.sqs_lambda.handler"` | no |
| dd\_log\_level | Lambda environment var for `datadog-lambda` DD\_LOG\_LEVEL setting | `string` | `"INFO"` | no |
| dd\_profiling\_enabled | Whether to enable profiling for Lambdas (DD APM requirement) | `string` | `"false"` | no |
| dd\_serverless\_logs\_enabled | Lambda environment var for `datadog-lambda` DD\_SERVERLESS\_LOGS\_ENABLED setting (true when using Datadog Lambda Extension; false when using Datadog Forwarder via Cloudwatch logs) | `string` | `"true"` | no |
| dd\_service | Datadog service name for the Lambda | `string` | `"hermosa-events-consumer"` | no |
| dd\_trace\_enabled | Lambda environment var for `datadog-lambda` DD\_TRACE\_ENABLED setting | `string` | `"true"` | no |
| env | unique environment name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| function\_response\_types | n/a | `list` | ```[ "ReportBatchItemFailures" ]``` | no |
| lambda\_image\_config\_cmd | docker CMD for the lambda | `list` | `[]` | no |
| lambda\_image\_config\_entry\_point | docker entry point for the lambda | `list` | `[]` | no |
| lambda\_image\_version | lambda ECR image version | `string` | `"main"` | no |
| lambda\_mapping\_batch\_size | max number of messages to send per invocation | `number` | `5` | no |
| lambda\_maximum\_batching\_window\_in\_seconds | max number of seconds to assemble batch | `number` | `5` | no |
| lambda\_memory\_size | lambda memory allocation | `number` | `1024` | no |
| lambda\_name | lambda function name associated with service | `string` | `"hermosa_lambda"` | no |
| lambda\_reserved\_concurrent\_executions | max number of lambda concurrent executions | `number` | `500` | no |
| lambda\_timeout | lambda timeout seconds | `number` | `360` | no |
| log\_level | Lambda environment var for `app` LOG\_LEVEL setting | `string` | `"INFO"` | no |
| maximum\_concurrency | n/a | `string` | `"300"` | no |
| ops\_config\_version | version of ops repository used to generate the configuration | `string` | `"master"` | no |
| service | unique service name | `string` | `"hermosa-events"` | no |
| sqs\_queue\_name | sqs queue name | `string` | `"hermosa-events"` | no |
| vpc\_name\_prefix | vpc name prefix | `any` | n/a | yes |



### Lessons Learned

### References

* [Hermosa Event handlers - Confluence](https://chownow.atlassian.net/l/cp/NZUxPjVe)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->