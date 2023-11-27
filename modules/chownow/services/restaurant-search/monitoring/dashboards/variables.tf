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

variable "dm_service_name" {
  description = "unique service name for DMS migration and replica"
  default     = "restaurant-search-dm"
}

variable "etl_service_name" {
  description = "unique service name for the etl"
  default     = "restaurant-search-etl"
}

variable "sns_topic_base_name" {
  description = "base name of sns topic -- the part of the name that doesn't include the env"
  default     = "cn-restaurant-events"
}

locals {
  env = "${var.env}${var.env_inst}"
}
