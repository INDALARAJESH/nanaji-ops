variable "service" {
  description = "unique service name"
  default     = "user-privacy"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix"
  default     = "nc"
}

variable "cors_allow_origins" {
  description = "comma separated list of allowed CORS origins"
  default     = ""
}

variable "env" {
  description = "unique environment name"
  default     = "dev"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "dd_flush_to_log" {
  description = "Lambda environment var for `datadog-lambda` DD_FLUSH_TO_LOG setting"
  default     = "true"
}

variable "dd_lambda_handler" {
  description = "Lambda environment var for `datadog-lambda` specifying entrypoint handler"
  default     = "run.lambda_handler"
}

variable "hermosa_host_url" {
  description = "Hermosa REST API Endpoint url"
  default     = "https://dev.chownow.com"
}

variable "dd_log_level" {
  description = "Lambda environment var for `datadog-lambda` DD_LOG_LEVEL setting"
  default     = "info"
}

variable "dd_trace_enabled" {
  description = "Lambda environment var for `datadog-lambda` DD_TRACE_ENABLED setting"
  default     = "true"
}

locals {
  env      = "${var.env}${var.env_inst}"
  app_name = lower(var.service)

  dd_site          = "datadoghq.com"
  dd_api_key_arn   = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/ops_api_key"
  datadog_env      = local.env == "ncp" ? "prod" : local.env
  service_mappings = "aws.lambda:${var.service},aws.secretsmanager:${var.service}-secretsmanager"
  span_tags        = "aws_env:${var.env} cn_namespace:${var.service}"

  lambda_env_variables_common = {
    DD_SITE                    = local.dd_site
    DD_API_KEY_SECRET_ARN      = local.dd_api_key_arn
    DD_ENV                     = local.datadog_env
    DD_SERVICE                 = var.service
    DD_FLUSH_TO_LOG            = var.dd_flush_to_log
    DD_LOG_LEVEL               = var.dd_log_level
    DD_SERVERLESS_LOGS_ENABLED = "true"
    DD_TRACE_ENABLED           = var.dd_trace_enabled
    DD_SERVICE_MAPPING         = local.service_mappings
    DD_TAGS                    = local.span_tags
    POWERTOOLS_SERVICE_NAME    = var.service
  }

  lambda_env_variables_user_privacy = {
    ONE_TRUST_CLIENT_ID                 = data.aws_secretsmanager_secret.one_trust_client_id.arn
    ONE_TRUST_CLIENT_SECRET             = data.aws_secretsmanager_secret.one_trust_client_secret.arn
    HERMOSA_API_KEY_USER_PRIVACY_LAMBDA = data.aws_secretsmanager_secret.hermosa_api_key_user_privacy_lambda.arn
    DD_LAMBDA_HANDLER                   = var.dd_lambda_handler
    HERMOSA_HOST                        = var.hermosa_host_url
  }

  access_log_settings = [{
    destination_arn = trimsuffix(data.aws_cloudwatch_log_group.gateway.arn, ":*")
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "resourcePath" : "$context.resourcePath", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength", "userAgent" : "$context.identity.userAgent", "integrationError" : "$context.integration.error", "sourceIp" : "$context.identity.sourceIp", "routeKey" : "$context.routeKey", "path" : "$context.path", "service" : "${var.service}-apigateway" })
  }]

  common_tags = {
    ManagedBy = var.tag_managed_by
  }

  extra_tags = {
    TFModule = "ops-tf-modules/modules/chownow/services/user-privacy/app" # Required for some base modules
  }
}
