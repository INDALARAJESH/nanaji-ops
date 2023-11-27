variable "service" {
  description = "unique service name"
  default     = "hermosa-events"
}

variable "low_priority_service" {
  description = "unique service name"
  default     = "hermosa-events-low-priority"
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

variable "vpc_name_prefix" {
  description = "vpc name prefix"
}

locals {
  env                                        = "${var.env}${var.env_inst}"
  lambda_classification                      = "${var.service}_${local.env}"
  vpc_name                                   = var.vpc_name_prefix != "" ? "${var.vpc_name_prefix}-${local.env}" : local.env
  standard_queue_allowed_topic_subscriptions = compact([var.sns_memberships_topic_arn, var.sns_order_delivery_topic_arn])
  has_custom_standard_queue_policy           = length(local.standard_queue_allowed_topic_subscriptions) != 0
}
