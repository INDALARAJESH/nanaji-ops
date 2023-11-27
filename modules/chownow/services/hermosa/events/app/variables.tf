variable "service" {
  description = "unique service name"
  default     = "hermosa-events"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "app_name" {
  description = "app name"
  default     = "hermosa"
}

variable "sqs_queue_name" {
  description = "sqs queue name"
  default     = "hermosa-events"
}

variable "low_priority_sqs_queue_name" {
  description = "sqs queue name"
  default     = "hermosa-events-low-priority"
}

variable "log_level" {
  description = "Lambda environment var for `app` LOG_LEVEL setting"
  default     = "INFO"
}

variable "dd_service" {
  description = "Datadog service name for the Lambda"
  default     = "hermosa-events-consumer"
}

variable "dd_flush_to_log" {
  description = "Lambda environment var for `datadog-lambda` DD_FLUSH_TO_LOG setting"
  default     = "true"
}

variable "dd_log_level" {
  description = "Lambda environment var for `datadog-lambda` DD_LOG_LEVEL setting"
  default     = "INFO"
}

variable "dd_trace_enabled" {
  description = "Lambda environment var for `datadog-lambda` DD_TRACE_ENABLED setting"
  default     = "true"
}

variable "dd_serverless_logs_enabled" {
  description = "Lambda environment var for `datadog-lambda` DD_SERVERLESS_LOGS_ENABLED setting (true when using Datadog Lambda Extension; false when using Datadog Forwarder via Cloudwatch logs)"
  default     = "true"
}

variable "dd_enhanced_metrics" {
  # Generate enhanced Datadog Lambda integration metrics, such as, aws.lambda.enhanced.invocations and aws.lambda.enhanced.errors. Defaults to true.
  description = "Lambda environment var for `datadog-lambda` DD_ENHANCED_METRICS setting (may affect AWS bill when used with Datadog Forwarder via Cloudwatch logs; to opt-out set it to false)"
  default     = "true"
}

variable "dd_profiling_enabled" {
  description = "Whether to enable profiling for Lambdas (DD APM requirement)"
  default     = "false"
}

variable "ops_config_version" {
  description = "version of ops repository used to generate the configuration"
  default     = "master"
}

variable "function_response_types" {
  default = ["ReportBatchItemFailures"]
}

variable "maximum_concurrency" {
  default = "300"
}

locals {
  env                                = "${var.env}${var.env_inst}"
  datadog_env                        = local.env == "ncp" ? "prod" : local.env
  lambda_classification              = "${var.service}_${local.env}"
  lambda_low_priority_classification = "${var.low_priority_sqs_queue_name}_${local.env}"
  lambda_image_uri                   = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa-lambda:${var.lambda_image_version}"

  lambda_env_variables = {
    CONFIG_SECRET_ARN          = data.aws_secretsmanager_secret.configuration.arn
    DD_API_KEY_SECRET_ARN      = data.aws_secretsmanager_secret.datadog_ops_api_key.arn
    DD_ENHANCED_METRICS        = var.dd_enhanced_metrics
    DD_ENV                     = local.datadog_env
    DD_FLUSH_TO_LOG            = var.dd_flush_to_log
    DD_LAMBDA_HANDLER          = var.dd_lambda_handler
    DD_LOG_LEVEL               = var.dd_log_level
    DD_PROFILING_ENABLED       = var.dd_profiling_enabled
    DD_SERVERLESS_LOGS_ENABLED = var.dd_serverless_logs_enabled
    DD_SERVICE                 = var.dd_service
    DD_SERVICE_MAPPING         = "redis:hermosa-redis,mysql:hermosa-mysql,requests:hermosa-requests,elasticsearch:hermosa-elasticsearch,sqlite:hermosa-sqlite,kms:hermosa-kms,aws.sns:hermosa-sns,aws.s3:hermosa-s3,aws.kms:hermosa-kms,aws.sqs:hermosa-sqs,aws.lambda:${var.dd_service},cn_namespace:${var.dd_service}"
    DD_TRACE_ENABLED           = var.dd_trace_enabled
    DD_VERSION                 = "${var.lambda_image_version}-${var.ops_config_version}"
    DD_TAG                     = "env:${local.env},config_version:${var.ops_config_version},cn_namespace:${var.service},version:${var.lambda_image_version}"
    LOG_LEVEL                  = var.log_level
    ENV                        = local.env
    GIT_SHA                    = var.lambda_image_version
  }

  extra_tags = {
    TFModule = "modules/chownow/services/${var.app_name}/lambda/app"
    Owner    = "pantry"
  }
}
