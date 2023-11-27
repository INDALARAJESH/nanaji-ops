variable "service" {
  description = "unique service name for project/application"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "owner" {
  description = "responsible party for this datadog monitor"
}

variable "name_prefix" {
  description = "datadog monitor name prefix"
}

locals {
  env          = "${var.env}${var.env_inst}"
  monitor_name = var.custom_monitor_name != "" ? var.custom_monitor_name : "${var.name_prefix}-${var.service}-${local.env}"
}
