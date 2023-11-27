## Web Container Vars
variable "web_container_image_version" {
  description = "the image version used to start the web container"
  default     = "web-latest"
}

variable "web_container_integrator_request_rate" {
  description = "request rate limit per integrating partner"
  default     = "100/minute"
}

variable "web_container_log_level" {
  description = "log level environment variable for web container"
  default     = "INFO"
}

variable "web_container_port" {
  description = "web container ingress TCP port"
  default     = "8000"
}

variable "web_container_is_sandbox" {
  description = "web container sandbox boolean"
  default     = "False"
}

variable "web_container_restaurants_locations_rate" {
  description = "request rate limit for restaurant locations"
  default     = "3/minute"
}

variable "web_container_restaurants_orders_list_burst_rate" {
  description = "request rate limit to throttle order list requests per minute"
  default     = "4/minute"
}

variable "web_container_restaurants_orders_list_sustained_rate" {
  description = "request rate limit to throttle order list requests per hour"
  default     = "90/hour"
}

variable "web_container_restaurants_orders_rate" {
  description = "request rate limit for order details per restaurant"
  default     = "10/minute"
}

variable "web_container_user_request_rate" {
  description = "user throttling limit to set for web container"
  default     = "200/minute"
}

variable "web_container_xff_proxy_depth" {
  description = "X-Forwarded-For trusted proxy depth. CloudFlare adds an additional IP."
  default     = "1"
}

variable "web_ecr_repository_uri" {
  description = "ECR repository uri for the web container"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/integrations-web-ops"
}

variable "web_ecs_service_desired_count" {
  description = "desired number of web task instances to run"
  default     = 1
}

variable "web_ecs_service_max_count" {
  description = "max number of web task instances to run"
  default     = 8
}

## Manage Container Vars

variable "manage_container_image_version" {
  description = "the manage container image version"
  default     = "manage-latest"
}

variable "manage_container_port" {
  description = "manage container ingress TCP port"
  default     = "8000"
}

variable "manage_container_snowflake_bucket_name" {
  description = "snowflake s3 bucket name"
  default     = "cn-snowflake-prod"
}

variable "manage_ecr_repository_uri" {
  description = "ECR repository uri for the manage container"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/integrations-manage-ops"
}

## Manage Container Event Vars

variable "event_cron_is_enabled" {
  description = "boolean toggle to enable the manage task event cron process"
  default     = false
}

variable "event_cron_schedule" {
  description = "scheduled UTC cron expression to run event cron process. defaults to 1am pst"
  default     = "cron(0 9 * * ? *)"
}

variable "event_container_override_command" {
  description = "container override command to pass to the manage task event cron process"
  default     = "python\",\"manage.py\",\"snowflakeetl"
}

## Middleware Vars

variable "hermosa_api_url" {
  description = "hermosa api url"
  default     = ""
}

variable "hermosa_admin_url" {
  description = "hermosa admin url"
  default     = ""
}

variable "postgresql_port" {
  description = "postgresql port"
  default     = "5432"
}

variable "redis_port" {
  description = "redis port"
  default     = "6379"
}

## Firelens Vars

variable "firelens_container_name" {
  description = "firelens container name"
  default     = "log_router"
}

variable "firelens_container_ssm_parameter_name" {
  description = "firelens container ssm parameter name"
  default     = "/aws/service/aws-for-fluent-bit"
}

variable "firelens_container_image_version" {
  description = "firelens container image version (tag)"
  default     = "2.10.1"
}

variable "firelens_options_dd_host" {
  description = "Host URI of the datadog log endpoint"
  default     = "http-intake.logs.datadoghq.com"
}

variable "td_cpu" {
  description = "ECS task definition cpu mode"
  default     = "1024"
}

variable "td_memory" {
  description = "ECS task definition memory allocation"
  default     = "2048"
}

locals {
  web_container_name    = "${local.full_service}-web-${local.env}"
  manage_container_name = "${local.full_service}-manage-${local.env}"
  hermosa_api_url       = var.hermosa_api_url == "" ? "https://api.${local.env}.svpn.chownow.com" : var.hermosa_api_url
  hermosa_admin_url     = var.hermosa_admin_url == "" ? "https://admin.${local.env}.svpn.chownow.com" : var.hermosa_admin_url
}
