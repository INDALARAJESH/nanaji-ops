variable "etl_service_name" {
  description = "unique service name for the etl"
  default     = "restaurant-search-etl"
}

variable "api_service_name" {
  description = "unique service name for the api"
  default     = "restaurant-search-api"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "etl_dashboard_layout_type" {
  description = "layout type for etl dashboard"
  default     = "free"
}

variable "sns_topic_base_name" {
  description = "base name of sns topic -- the part of the name that doesn't include the env"
  default     = "cn-restaurant-events"
}

variable "dd_base_webhook_url" {
  description = "base path for datadog webhook url"
  default     = "https://app.datadoghq.com/intake/webhook/sns?api_key="
}

variable "dm_source_database_name" {
  description = "DMS source database for data replication from Hermosa"
  default     = "hermosa"
}


variable "dm_service_name" {
  description = "unique service name for DMS migration and replica"
  default     = "restaurant-search-dm"
}

variable "alert_notify_list" {
  description = "The list of tags to notify when an alert is raised"
  type        = list(string)
  default     = ["@slack-chefs-toys-monitoring-dev"]
}

variable "warn_notify_list" {
  description = "The list of tags to notify when a warning is raised"
  type        = list(string)
  default     = ["@slack-chefs-toys-monitoring-dev"]
}

variable "service_name" {
  description = "service name for rss"
  default     = "restaurant-search"
}

variable "proxy_service_name" {
  description = "service name for the proxy"
  default     = "hermosa-api"
}

variable "proxy_resource_name" {
  description = "resource name for the proxy"
  default     = "get_/api/restaurant"
}

locals {
  env                             = "${var.env}${var.env_inst}"
  dd_webhook_url                  = "${var.dd_base_webhook_url}${data.aws_secretsmanager_secret_version.restaurant_search_dd_api_key.secret_string}"
  dms_replication_instance        = "repl-${var.dm_service_name}-${local.env}"
  dms_replication_task_identifier = "sync-${var.dm_source_database_name}-${var.dm_service_name}-${local.env}"
  dashboard_url_api               = "https://app.datadoghq.com${data.datadog_dashboard.api.url}?tpl_var_env%5B0%5D=${local.env}&tpl_var_hermosa_env%5B0%5D=${local.env}"
  dashboard_url_etl               = "https://app.datadoghq.com${data.datadog_dashboard.etl.url}?tpl_var_env%5B0%5D=${local.env}"
  proxy_env                       = var.env == "ncp" ? "prod" : var.env
  proxy_env_full                  = "${local.proxy_env}${var.env_inst}"
}
