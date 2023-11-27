variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "webhook_allowed_ip_ranges" {
  description = "Allow list of IP addresses that can access webhook api gateway. Defaults to cloudflare IPs"
  type        = list(string)
  default     = ["173.245.48.0/20", "103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "141.101.64.0/18", "108.162.192.0/18", "190.93.240.0/20", "188.114.96.0/20", "197.234.240.0/22", "198.41.128.0/17", "162.158.0.0/15", "104.16.0.0/13", "104.24.0.0/14", "172.64.0.0/13", "131.0.72.0/22"]
}

variable "source_vpc_endpoint_ids" {
  description = "Source VPC Endpoint IDS of the VPC that is allowed to interface with the private api gateway"
  type        = list(string)
  default     = []
}

variable "lambda_timeout" {
  description = "amount of time lambda function has to run in seconds"
  default     = 300
}

variable "lambda_memory_size" {
  description = "amount of memory in MB for lambda function"
  default     = 256
}

variable "cloudwatch_logs_retention" {
  description = "CloudWatch logs retention in days"
  default     = 14
}

variable "lambda_image_tag" {
  description = "image tag for the webhook lambdas"
  type        = string
}

variable "webhook_processor_lambda_command" {
  description = "the handler command for the webhook processor"
  type        = string
  default     = "webhook.webhook_handler.app.handler"
}

variable "webhook_partner_lambda_command" {
  description = "the handler command for the partner event handler container"
  type        = string
  default     = "webhook.partner_handler.app.handler"
}

variable "webhook_menu_lambda_command" {
  description = "the handler command for the menu event handler container"
  type        = string
  default     = "webhook.menu_handler.app.handler"
}

variable "webhook_stock_lambda_command" {
  description = "the handler command for the stock event handler container"
  type        = string
  default     = "webhook.stock_handler.app.handler"
}

variable "api_get_restaurant_lambda_command" {
  description = "the command for the get restaurant api lambda container"
  type        = string
  default     = "api.restaurants.get.app.handler"
}

variable "api_get_restaurant_locations_lambda_command" {
  description = "the command for the get restaurant locations api lambda container"
  type        = string
  default     = "api.restaurants.locations.get.app.handler"
}

variable "api_get_restaurant_errors_lambda_command" {
  description = "the command for the get restaurant integration errors api lambda container"
  type        = string
  default     = "api.restaurants.integration_errors.get.app.handler"
}

variable "api_get_order_prices_lambda_command" {
  description = "the handler command for the get order prices handler"
  type        = string
  default     = "api.restaurants.orders.prices.post.app.handler"
}

variable "api_patch_restaurant_lambda_command" {
  description = "the handler command for the patch restaurant handler"
  type        = string
  default     = "api.restaurants.patch.app.handler"
}

variable "api_post_authorization_url_lambda_command" {
  description = "the handler command for the post authorization url handler"
  type        = string
  default     = "api.authorization_url.post.app.handler"
}

variable "api_post_order_lambda_command" {
  description = "the handler command for the post order handler"
  type        = string
  default     = "api.restaurants.orders.post.app.handler"
}

variable "menu_metadata_checker_command" {
  description = "the handler command for the menu metadata checker handler"
  type        = string
  default     = "handlers.menu_metadata_checker.handler"
}

variable "resto_config_validator_command" {
  description = "the handler command for the restaurant config validator cron"
  type        = string
  default     = "handlers.restaurant_config_validator.handler"
}

variable "toast_url" {
  description = "url for toast api"
  type        = string
}

variable "toast_external_id_prefix" {
  description = "The prefix for external Ids in the Toast API. The value will be the Toast client name."
  type        = string
}

variable "hermosa_url" {
  description = "url for hermosa api"
  type        = string
}

variable "hermosa_admin_base_url" {
  description = "url for hermosa admin"
  type        = string
}

variable "lambda_vpc_id" {
  description = "VPC id for which lambdas that need VPC access will be deployed into"
  type        = string
  default     = ""
}

variable "lambda_vpc_subnet_ids" {
  description = "list of subnet ids to launch the lambda into"
  type        = list(string)
  default     = []
}

variable "lambda_provisioned_concurrency" {
  description = "Manages a Lambda Provisioned Concurrency Configuration"
  type        = number
  default     = 0
}

variable "enable_lambda_autoscaling" {
  description = "Whether to enable Application AutoScaling - operates on Provisioned concurrency"
  type        = bool
  default     = false
}

variable "lambda_autoscaling_min_capacity" {
  description = "The min capacity of the scalable target"
  type        = number
  default     = 1
}

variable "lambda_autoscaling_max_capacity" {
  description = "The max capacity of the scalable target"
  type        = number
  default     = 5
}

variable "lambda_provisioned_concurrency_autoscaling_target" {
  description = "Target utilization of provisioned concurrency in which to trigger autoscaling. For example 0.55 means to scale when 55% of provisioned concurrency is utilized"
  type        = number
  default     = 0.55
}

variable "enable_dynamo_pitr" {
  description = "A boolean value to enable/disable the point_in_time_recovery of the dynamodb resource."
  type        = bool
  default     = false
}

variable "enable_dynamo_stream" {
  description = "A boolean value to enable/disable dynamodb streams."
  type        = bool
  default     = false
}

variable "enable_fivetran_dynamo_integration" {
  description = "A boolean value to enable/disable fivetran integration with our dynamo streams. This is used by DnA to ingest data from our service. Note: dynamo streams must be enabled"
  type        = bool
  default     = false
}

variable "datadog_log_level" {
  description = "Datadog agent log level"
  type        = string
  default     = "ERROR"
}

locals {
  env                  = "${var.env}${var.env_inst}"
  service              = "pos-toast-integration"
  ssm_prefix           = "/${local.service}/${local.env}"
  ssm_toast_token      = "${local.ssm_prefix}/toast_access_token"
  image_repository_url = "449190145484.dkr.ecr.us-east-1.amazonaws.com/pos-toast-service"
  image_repository_arn = "arn:aws:ecr:us-east-1:449190145484:repository/pos-toast-service"

  datadog_env_vars = {
    DD_ENV                = var.env == "ncp" ? "prod" : local.env
    DD_SERVICE            = local.service
    DD_LOG_LEVEL          = var.datadog_log_level
    DD_TRACE_ENABLED      = "true"
    DD_API_KEY_SECRET_ARN = aws_secretsmanager_secret.dd_api_key.arn
  }
}
