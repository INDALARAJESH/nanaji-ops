# Loyalty Service App

### General

* Description: Loyalty Service app terraform module.
  This module creates resources used by the loyalty service.
* Created By: Warren Nisley
* Module Dependencies:
* Module Components: `loyalty-service-app`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-loyalty-service-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-loyalty-service-app/badge.svg)

### Usage

* Terraform (in lower environments):

```hcl
module "loyalty_service_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/loyalty/service/app?ref=loyalty-service-app-v2.2.3"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```

* Terraform (in NCP, to allow PROD account access to the SNS topic):

```hcl
module "loyalty_service_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/loyalty/service/app?ref=loyalty-service-app-v2.2.3"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  sns_cross_account_access_arn = "arn:aws:iam::234359455876:root"
}
```



### Initialization

### Terraform

* Run the Loyalty service app module in `loyalty/service/app` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── loyalty
          └── base
          └── service
            ├── base
            └── app
                ├── alb.tf
                ├── alb_variables.tf
                ├── data_source.tf
                ├── data_source_variables.tf
                ├── ecs.tf
                ├── ecs_variables.tf
                ├── logs.tf
                ├── templates.tf
                ├── templates_variables.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| service                       | service name                            | loyalty-service          | string |    Yes    | N/A            |
|image_tag         | git sha of the docker image             | n/a                      | string |    Yes    | N/A            |
|`alb_enable_egress_allow_all`	| | | string | | |
|`alb_ingress_tcp_allowed`	| | | | | |
|`alb_log_bucket`		        | | | | | |
|`alb_logs_enabled`		| | | | | |
|`alb_name_prefix`		| | | | | |
|`alb_tg_listener_protocol`	| | | | | |
|`alb_tg_target_type`		| | | | | |
|`app_name`		        |application short name |loyalty | string | No | N/A |
|`container_entrypoint`		| | | | | |
|`container_port`		        | | | | | |
|`container_protocol`		| | | | | |
|`dd_enhanced_metrics`		| | | | | |
|`dd_flush_to_log`		| | | | | |
|`dd_log_level`		        | | | | | |
|`dd_profiling_enabled`		| | | | | |
|`dd_serverless_logs_enabled`	| | | | | |
|`dd_service_mapping`		| | | | | |
|`dd_trace_enabled`		| | | | | |
|`domain`		                | | | | | |
|`ecs_service_desired_count`		| | | | | |
|`firelens_container_image_version`	| | | | | |
|`firelens_container_name`		| | | | | |
|`firelens_container_ssm_parameter_name`	| | | | | |
|`firelens_options_dd_host`		| | | | | |
|`host_port`		                | | | | | |
|`image_repository_arn`		        | | | | | |
|`log_level`		        | | | | | |
|`log_retention_in_days`		| | | | | |
|`loyalty_log_level`		| | | | | |
|`salesforce_cloudwatch_schedule_expression`		| | | | | |
|`salesforce_dd_lambda_handler`	        | | | | | |
|`salesforce_lambda_cron_boolean`	|enable/disable salesforce query |true | | | |
|`salesforce_lambda_image_config_cmd`	|timing of salesforce query |cron(15 * * * ? *) | | | |
|`salesforce_lambda_memory_size`		| |1024 | | | |
|`salesforce_lambda_name`		        | | | | | |
|`salesforce_lambda_timeout`	| |300 | | | |
|`sentry_event_level`	        | | | | | |
|`sf_api_domain`	                | | | | | |
|`sf_api_version`	                | | | | | |
|`sqs_dd_lambda_handler`	        | | | | | |
|`sqs_lambda_image_config_cmd`	| | | | | |
|`sqs_lambda_mapping_batch_size`	| | | | | |
|`sqs_lambda_memory_size`	        | | 848| | | |
|`sqs_lambda_name`	        | | | | | |
|`sqs_lambda_timeout`	        | | 300| | | |
|`sqs_refresh_cron_boolean`		|enable/disable refresh |true | | | |
|`sqs_refresh_schedule_expression`	|timing of refresh |cron(0 16 ? * SUN *) | | | |
|`sqs_queue_name`	                |name of the sqs queue |memberships | | | |
|`tg_health_check_target`	        | | | | | |
|`vpc_name_prefix`	        | | | | | |
|`vpc_private_subnet_tag_key`	| | | | | |
|`wildcard_domain_prefix`	        | | | | | |
|`sns_cross_account_access_arn`|account ARN to allow access to the topic||string|||


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References

* [Loyalty Service - Confluence](https://chownow.atlassian.net/wiki/spaces/CE/pages/2240742157/ChowNow+Loyalty+Service)
