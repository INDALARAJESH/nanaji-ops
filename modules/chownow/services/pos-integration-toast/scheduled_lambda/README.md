<!-- BEGIN_TF_DOCS -->
# Toast POS Service Scheduled Lambda Module

### General

* Description: A sub-module to POS toast integration service
* Created By: Rafal Fiedosiuk and Kacper Stasica
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

The goal is to implement a reusable module with EventBridge + Lambda combination, which integrates with different components of POS Integration toast service such as partner & menu sync handler. This module is designed with a flow where Lambda will be invoked by an EventBridge rule (schedule expression).


## Usage

* Terraform:

```hcl
module "menu_metadata_checker" {
  source                           = "./scheduled_lambda"
  service                          = local.service
  env                              = local.env
  lambda_name                      = "menu-metadata-checker"
  lambda_image_tag                 = var.lambda_image_tag
  lambda_base_policy_arn           = aws_iam_policy.lambda_base.arn
  image_repository_url             = local.image_repository_url
  event_bridge_schedule_expression = "rate(30 minutes)"

  environment_variables = merge(
    {
      DYNAMODB_TABLE                     = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL                       = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER                  = var.menu_metadata_checker_command
      GSI_1_NAME                         = local.db_cn_restaurant_gsi_name
      MENUS_EVENT_QUEUE_NAME             = aws_ssm_parameter.menus_event_queue_name.value
      KMS_KEY_ALIAS                      = aws_ssm_parameter.kms_key_alias.value
      TOAST_URL                          = aws_ssm_parameter.toast_url.value
      TOAST_TOKEN_PARAMETER_NAME         = local.ssm_toast_token
      TOAST_CLIENT_ID_PARAMETER_NAME     = aws_ssm_parameter.toast_client_id.name
      TOAST_CLIENT_SECRET_PARAMETER_NAME = aws_ssm_parameter.toast_client_secret.name
    },
    local.datadog_env_vars
  )
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_logs\_retention | CloudWatch logs retention in days | `number` | `14` | no |
| env | Env name | `any` | n/a | yes |
| environment\_variables | map of environment variables for the lambda function | `map(string)` | `{}` | no |
| event\_bridge\_schedule\_expression | EventBridge schedule expression | `any` | n/a | yes |
| image\_repository\_url | Image repository url | `any` | n/a | yes |
| lambda\_base\_policy\_arn | Base AWS IAM policy arn for all service lambdas | `any` | n/a | yes |
| lambda\_image\_tag | Handler lambda image tag. | `any` | n/a | yes |
| lambda\_memory\_size | amount of memory in MB for lambda function | `number` | `128` | no |
| lambda\_name | Lambda name | `any` | n/a | yes |
| lambda\_timeout | amount of time lambda function has to run in seconds | `number` | `300` | no |
| service | Service name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | the arn of the scheduled lambda |
| lambda\_name | the name of the scheduled lambda |
| lambda\_role\_arn | the arn of the scheduled lambda's role |
| lambda\_role\_name | the name of the scheduled lambda's role |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->