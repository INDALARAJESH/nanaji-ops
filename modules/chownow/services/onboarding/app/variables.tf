variable "name" {
  description = "unique name"
  default     = "self-service"
}

variable "service" {
  description = "unique service name"
  default     = "onboarding"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix"
  default     = "nc"
}

variable "cors_allow_origin_url" {
  description = "allowed origin for CORS headers"
  default     = "https://dashboard.chownow.com"
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
  default     = "app.lambda_handler"
}

variable "dd_log_level" {
  description = "Lambda environment var for `datadog-lambda` DD_LOG_LEVEL setting"
  default     = "info"
}

variable "dd_trace_enabled" {
  description = "Lambda environment var for `datadog-lambda` DD_TRACE_ENABLED setting"
  default     = "true"
}

variable "sfdc_integration_partner_prefix" {
  description = "The name of the Salesforce integration partner"
  default     = "aws.partner/appflow/salesforce.com"
}

variable "sfdc_appflow_subscribed_event_names" {
  description = "A list of SFDC events (string) to subscribe to via AppFlow"
  default = [
    "Menu_File_Status_Change__e",
    "Restaurant_schedule__e",
    "Food_Image_File_Status_Change__e",
    "Logo_File_Status_Change__e",
  ]
}

locals {
  env      = format("%s%s", var.env, var.env_inst)
  app_name = format("%s-%s", lower(var.name), lower(var.service))
  service  = format("%s-%s", lower(var.name), lower(var.service))

  schedule_table_name                = "${var.service}-schedule-${lower(local.env)}"
  menu_link_table_name               = "${var.service}-menu-link-${lower(local.env)}"
  assets_upload_url_table_name       = "${var.service}-assets-upload-url-${lower(local.env)}"
  salesforce_client_cache_table_name = "${var.service}-salesforce-client-cache-${lower(local.env)}"
  progress_table_name                = "${var.service}-progress-${lower(local.env)}"
  website_access_table_name          = "${var.service}-website-access-${lower(local.env)}"
  promotion_table_name               = "${var.service}-promotion-${lower(local.env)}"
  onboarding_table_name              = "${var.service}-onboarding-${lower(local.env)}"

  onboarding_files_s3_bucket_name = "cn-${var.service}-files-${var.env}"
  s3_presign_url_expiration       = 60
  s3_presign_url_long_expiration  = 3600

  sfdc_event_bus_name    = "${var.service}-sfdc-event-bus-${local.env}"
  sfdc_appflow_connector = "${var.service}-sfdc-connector-${local.env}"

  dd_site          = "datadoghq.com"
  dd_api_key_arn   = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/ops_api_key"
  datadog_env      = local.env == "ncp" ? "prod" : local.env
  service_mappings = "aws.lambda:${var.service},aws.dynamodb:${var.service}-dynamodb,aws.secretsmanager:${var.service}-secretsmanager"
  span_tags        = "aws_env:${var.env} cn_namespace:${var.service}"

  lambda_env_variables_common = {
    DD_SITE                            = local.dd_site
    DD_API_KEY_SECRET_ARN              = local.dd_api_key_arn
    DD_ENV                             = local.datadog_env
    DD_SERVICE                         = var.service
    DD_FLUSH_TO_LOG                    = var.dd_flush_to_log
    DD_LOG_LEVEL                       = var.dd_log_level
    DD_SERVERLESS_LOGS_ENABLED         = "true"
    DD_TRACE_ENABLED                   = var.dd_trace_enabled
    DD_SERVICE_MAPPING                 = local.service_mappings
    DD_TAGS                            = local.span_tags
    POWERTOOLS_SERVICE_NAME            = var.service
    CORS_ALLOW_ORIGIN_URL              = var.cors_allow_origin_url
    LOG_LEVEL                          = local.env == "ncp" ? "INFO" : "DEBUG"
    SFDC_TOKEN                         = data.aws_secretsmanager_secret.sfdc_token.arn,
    SFDC_CLIENT_ID                     = var.sfdc_client_id
    SFDC_CLIENT_SECRET                 = data.aws_secretsmanager_secret.sfdc_client_secret.arn,
    SFDC_PASSWORD                      = data.aws_secretsmanager_secret.sfdc_password.arn,
    SFDC_DOMAIN_NAME                   = var.sfdc_domain_name
    SFDC_USERNAME                      = var.sfdc_user_name
    ASSETS_UPLOAD_URL_TABLE_NAME       = local.assets_upload_url_table_name
    SALESFORCE_CLIENT_CACHE_TABLE_NAME = local.salesforce_client_cache_table_name
    PROGRESS_TABLE_NAME                = local.progress_table_name
    SCHEDULE_TABLE_NAME                = local.schedule_table_name
    MENU_LINK_TABLE_NAME               = local.menu_link_table_name
    WEBSITE_ACCESS_TABLE_NAME          = local.website_access_table_name
    PROMOTION_TABLE_NAME               = local.promotion_table_name
    ONBOARDING_TABLE_NAME              = local.onboarding_table_name
    S3_BUCKET_NAME                     = local.onboarding_files_s3_bucket_name
    S3_PRESIGN_URL_EXPIRATION          = local.s3_presign_url_expiration
  }

  api_gateway_event_handler_lambda_env_variables = {
    DD_LAMBDA_HANDLER = "functions.api_gateway_event_handler.${var.dd_lambda_handler}"
  }

  presigned_url_lambda_env_variables = {
    DD_LAMBDA_HANDLER = "functions.presigned_url.${var.dd_lambda_handler}"
  }

  event_bridge_event_handler_lambda_env_variables = {
    DD_LAMBDA_HANDLER = "functions.event_bridge_event_handler.${var.dd_lambda_handler}"
  }

  access_log_settings = [{
    destination_arn = trimsuffix(data.aws_cloudwatch_log_group.gateway.arn, ":*")
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "resourcePath" : "$context.resourcePath", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength", "userAgent" : "$context.identity.userAgent", "integrationError" : "$context.integration.error", "sourceIp" : "$context.identity.sourceIp", "routeKey" : "$context.routeKey", "path" : "$context.path", "service" : "onboarding-apigateway" })
  }]

  common_tags = {
    ManagedBy = var.tag_managed_by
  }

  extra_tags = {
    TFModule = "ops-tf-modules/modules/chownow/services/onboarding/app" # Required for some base modules
  }
}
