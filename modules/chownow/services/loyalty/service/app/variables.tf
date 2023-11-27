variable "app_name" {
  description = "short name of app"
  default     = "loyalty"
}

variable "service" {
  description = "name of app/service"
  default     = "loyalty-service"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "image_tag" {
  description = "service image tag"
  default     = "wn-cn-26320_periodic_refresh"
}

variable "log_level" {
  description = "Python environment var for LOG_LEVEL setting"
  default     = "INFO"
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "main"
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

variable "sf_api_domain" {
  description = "salesforce api domain"
  default     = "test"
}

variable "sf_api_version" {
  description = "salesforce api service version"
  default     = "36.0"
}

variable "sqs_queue_name" {
  description = "name of the sqs queue"
  default     = "memberships"
}

variable "sentry_event_level" {
  description = "level to send to sentry"
  default     = "ERROR"
}

variable "launchdarkly_enabled" {
  description = "Whether to enable launchdarkly"
  default     = "true"
}

locals {
  env            = "${var.env}${var.env_inst}"
  container_name = "${var.service}-${local.env}"
  datadog_env    = local.env == "ncp" ? "prod" : local.env
  dns_zone       = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  table_name     = "${var.app_name}-dynamodb-${local.env}"
  sqs_queue_name = "${var.sqs_queue_name}_${local.env}"

  sqs_lambda_classification = "${var.sqs_lambda_name}_${local.env}"
  sqs_lambda_image_uri      = "${var.image_repository_arn}:${var.image_tag}"

  salesforce_lambda_classification = "${var.salesforce_lambda_name}_${local.env}"
  salesforce_lambda_image_uri      = "${var.image_repository_arn}:${var.image_tag}"

  sqs_lambda_env_variables = {
    DD_API_KEY_SECRET_ARN      = data.aws_secretsmanager_secret.datadog_ops_api_key.arn
    DD_ENHANCED_METRICS        = var.dd_enhanced_metrics
    DD_ENV                     = local.datadog_env
    DD_FLUSH_TO_LOG            = var.dd_flush_to_log
    DD_LAMBDA_HANDLER          = var.sqs_dd_lambda_handler
    DD_LOG_LEVEL               = var.dd_log_level
    DD_PROFILING_ENABLED       = var.dd_profiling_enabled
    DD_SERVERLESS_LOGS_ENABLED = var.dd_serverless_logs_enabled
    DD_SERVICE                 = var.service
    DD_SERVICE_MAPPING         = "pynamodb:loyalty-dynamodb,requests:loyalty-requests,aws.sns:sns-memberships-topic,aws.sqs:sqs-memberships-queue,aws.lambda:loyalty-sqs-lambda,cn_namespace:loyalty-sqs-lambda"
    DD_TRACE_ENABLED           = var.dd_trace_enabled
    DD_VERSION                 = var.image_tag
    ENV                        = local.env
    GIT_SHA                    = var.image_tag
    LAUNCHDARKLY_API_KEY_ARN   = data.aws_secretsmanager_secret.launchdarkly_sdk_key.arn
    LAUNCHDARKLY_ENABLED       = var.launchdarkly_enabled
    LOG_LEVEL                  = var.log_level
    LOYALTY_TABLE_NAME         = local.table_name
    SENTRY_DSN_ARN             = data.aws_secretsmanager_secret.sentry_dsn.arn
    SENTRY_EVENT_LEVEL         = var.sentry_event_level
    SERVICE_API_KEY_ARN        = data.aws_secretsmanager_secret.loyalty_api_key.arn
    SNS_TOPIC_ARN              = module.memberships-sns-topic.arn
  }

  salesforce_lambda_env_variables = {
    DD_API_KEY_SECRET_ARN      = data.aws_secretsmanager_secret.datadog_ops_api_key.arn
    DD_ENHANCED_METRICS        = var.dd_enhanced_metrics
    DD_ENV                     = local.datadog_env
    DD_FLUSH_TO_LOG            = var.dd_flush_to_log
    DD_LAMBDA_HANDLER          = var.salesforce_dd_lambda_handler
    DD_LOG_LEVEL               = var.dd_log_level
    DD_PROFILING_ENABLED       = var.dd_profiling_enabled
    DD_SERVERLESS_LOGS_ENABLED = var.dd_serverless_logs_enabled
    DD_SERVICE                 = var.service
    DD_SERVICE_MAPPING         = "pynamodb:loyalty-dynamodb,requests:loyalty-requests,aws.sqs:sqs-memberships-queue,aws.lambda:loyalty-salesforce-lambda,cn_namespace:loyalty-salesforce-lambda"
    DD_TRACE_ENABLED           = var.dd_trace_enabled
    DD_VERSION                 = var.image_tag
    ENV                        = local.env
    GIT_SHA                    = var.image_tag
    LAUNCHDARKLY_API_KEY_ARN   = data.aws_secretsmanager_secret.launchdarkly_sdk_key.arn
    LAUNCHDARKLY_ENABLED       = var.launchdarkly_enabled
    LOG_LEVEL                  = var.log_level
    LOYALTY_TABLE_NAME         = local.table_name
    SENTRY_DSN_ARN             = data.aws_secretsmanager_secret.sentry_dsn.arn
    SENTRY_EVENT_LEVEL         = var.sentry_event_level
    SERVICE_API_KEY_ARN        = data.aws_secretsmanager_secret.loyalty_api_key.arn
    SFDC_INTEGRATION_PASS_ARN  = data.aws_secretsmanager_secret.sfdc_integration_pass.arn
    SFDC_INTEGRATION_TOKEN_ARN = data.aws_secretsmanager_secret.sfdc_integration_token.arn
    SFDC_INTEGRATION_USER_ARN  = data.aws_secretsmanager_secret.sfdc_integration_user.arn
    SF_API_DOMAIN              = var.sf_api_domain
    SF_API_SERVICE_VERSION     = var.sf_api_version
    SQS_QUEUE_NAME             = local.sqs_queue_name
  }

  extra_tags = {
    TFModule = "modules/chownow/services/${var.service}/app"
    Owner    = "pantry"
  }
}
