# Channels Data Service App

## General

* Description: Channels Data Service app terraform module.
  This module creates the app (compute) resources used by the service.
* Created By: Wesley Jin
* Module Dependencies:
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-channels-data-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-channels-data-app/badge.svg)

## Usage, Latest Version

```hcl
module "channels_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/channels-data/app?ref=cn-channels-data-app-v2.5.1"
  
  env                  = var.env
  lambda_image_uri     = "${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/channels-data:349a98f"
  vpc_placement_subnets = module.data.nc_private_subnet_ids
}
```

2.4.7: add query limit lambda env var   
2.4.8: added Google PALs/Starter  
2.4.9: update Google Starter cron schedule
2.5.0: remove Seated Feed
2.5.1: add default_reply_to


## Providers

| Name                                                             | Version |
| ---------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws)                | n/a     |
| <a name="provider_template"></a> [template](#provider\_template) | n/a     |

## Modules

| Name                                                                                              | Source                                                                            | Version                          |
| ------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------------- |
| <a name="module_datadog_log_forward"></a> [datadog\_log\_forward](#module\_datadog\_log\_forward) | git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder | aws-datadog-log-forwarder-v2.0.2 |
| <a name="module_function"></a> [function](#module\_function)                                      | git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic          | aws-lambda-basic-v2.0.8          |

## Resources

| Name                                                                                                                                                                                | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_event_rule.apple_cron](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)                                           | resource    |
| [aws_cloudwatch_event_rule.menu_cron](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)                                            | resource    |
| [aws_cloudwatch_event_rule.opentable_cron](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)                                       | resource    |
| [aws_cloudwatch_event_rule.tripadvisor_cron](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)                                     | resource    |
| [aws_cloudwatch_event_target.apple_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)                                      | resource    |
| [aws_cloudwatch_event_target.menu_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)                                       | resource    |
| [aws_cloudwatch_event_target.opentable_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)                                  | resource    |
| [aws_cloudwatch_event_target.tripadvisor_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)                                | resource    |
| [aws_cloudwatch_log_subscription_filter.datadog_log_forward_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource    |
| [aws_docdb_cluster.cds_docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster)                                                            | resource    |
| [aws_docdb_cluster_instance.cds_i1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance)                                             | resource    |
| [aws_docdb_subnet_group.cds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group)                                                        | resource    |
| [aws_iam_policy.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                                                     | resource    |
| [aws_iam_role_policy_attachment.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)                                     | resource    |
| [aws_lambda_permission.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)                                                   | resource    |
| [aws_lambda_permission.cloudwatch_apple](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)                                             | resource    |
| [aws_lambda_permission.cloudwatch_menu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)                                              | resource    |
| [aws_lambda_permission.cloudwatch_opentable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)                                         | resource    |
| [aws_security_group.cds_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                                     | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                                       | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                                         | data source |
| [aws_subnet.subnet_metadata](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                                                                 | data source |
| [template_file.lambda_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                                             | data source |

## Inputs

| Name                                                                                                                             | Description                                                               | Type           | Default                                                                      | Required |
| -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | -------------- | ---------------------------------------------------------------------------- | :------: |
| <a name="input_cloudwatch_schedule_expression"></a> [cloudwatch\_schedule\_expression](#input\_cloudwatch\_schedule\_expression) | schedule in cron notation to run lambda                                   | `string`       | `"cron(0 10 * * ? *)"`                                                       |    no    |
| <a name="input_env"></a> [env](#input\_env)                                                                                      | unique environment name                                                   | `any`          | n/a                                                                          |   yes    |
| <a name="input_env_inst"></a> [env\_inst](#input\_env\_inst)                                                                     | environment instance, eg 01 added to stg01                                | `string`       | `""`                                                                         |    no    |
| <a name="input_lambda_cron_boolean"></a> [lambda\_cron\_boolean](#input\_lambda\_cron\_boolean)                                  | boolean for enabling lambda cron                                          | `bool`         | `true`                                                                       |    no    |
| <a name="input_lambda_ecr"></a> [lambda\_ecr](#input\_lambda\_ecr)                                                               | boolean for enabling ecr artifacts for lambda                             | `bool`         | `true`                                                                       |    no    |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler)                                                   | entry point of the generator lambda                                       | `string`       | `"src/app.snowflake_etl_handler"`                                            |    no    |
| <a name="input_lambda_image_uri"></a> [lambda\_image\_uri](#input\_lambda\_image\_uri)                                           | lambda ECR image URI                                                      | `string`       | `""`                                                                         |    no    |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size)                                     | lambda memory allocation                                                  | `number`       | `1024`                                                                       |    no    |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name)                                                            | lambda function name associated with service                              | `string`       | `"etl"`                                                                      |    no    |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime)                                                   | runtime associated with lambda                                            | `string`       | `"python3.9"`                                                                |    no    |
| <a name="input_lambda_s3"></a> [lambda\_s3](#input\_lambda\_s3)                                                                  | boolean for enabling s3 artifacts for lambda                              | `bool`         | `false`                                                                      |    no    |
| <a name="input_lev_dd_flush_to_log"></a> [lev\_dd\_flush\_to\_log](#input\_lev\_dd\_flush\_to\_log)                              | Lambda environment var for `datadog-lambda` DD\_FLUSH\_TO\_LOG setting    | `string`       | `"true"`                                                                     |    no    |
| <a name="input_lev_dd_lambda_handler"></a> [lev\_dd\_lambda\_handler](#input\_lev\_dd\_lambda\_handler)                          | Lambda environment var for `datadog-lambda` specifying entrypoint handler | `string`       | `"src.app.snowflake_etl_handler"`                                            |    no    |
| <a name="input_lev_dd_log_level"></a> [lev\_dd\_log\_level](#input\_lev\_dd\_log\_level)                                         | Lambda environment var for `datadog-lambda` DD\_LOG\_LEVEL setting        | `string`       | `"info"`                                                                     |    no    |
| <a name="input_lev_dd_trace_enabled"></a> [lev\_dd\_trace\_enabled](#input\_lev\_dd\_trace\_enabled)                             | Lambda environment var for `datadog-lambda` DD\_TRACE\_ENABLED setting    | `string`       | `"true"`                                                                     |    no    |
| <a name="input_lev_sentry_dsn"></a> [lev\_sentry\_dsn](#input\_lev\_sentry\_dsn)                                                 | Sentry DSN. The DSN tells the SDK where to send the events to.            | `string`       | `"https://e0b34cdd2e394ba58c4909d377665088@o32006.ingest.sentry.io/6058821"` |    no    |
| <a name="input_lev_snowflake_warehouse"></a> [lev\_snowflake\_warehouse](#input\_lev\_snowflake\_warehouse)                      | Snowflake warehouse (compute layer) to use for queries                    | `string`       | `"channels_service_wh"`                                                      |    no    |
| <a name="input_service"></a> [service](#input\_service)                                                                          | unique service name                                                       | `string`       | `"channels-data"`                                                            |    no    |
| <a name="input_vpc_placement_subnets"></a> [vpc\_placement\_subnets](#input\_vpc\_placement\_subnets)                            | subnets that the cds lambda function should execute from                  | `list(string)` | n/a                                                                          |   yes    |

## Outputs

| Name                                                                                        | Description                                                   |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| <a name="output_cds_membership_sg"></a> [cds\_membership\_sg](#output\_cds\_membership\_sg) | security group that allows mongodb traffic from group members |
