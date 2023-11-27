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

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "name_prefix" {
  description = "name prefix for security group"
  default     = ""
}

variable "alb_name" {
  description = "custom alb name"
  default     = ""
}

variable "security_group_name" {
  description = "custom security group name"
  default     = ""
}

locals {
  env                 = "${var.env}${var.env_inst}"
  alb_log_bucket      = var.custom_alb_log_bucket != "" ? var.custom_alb_log_bucket : "cn-alb-logs-${local.env}"
  alb_name            = var.alb_name != "" ? var.alb_name : var.name_prefix == "" ? "${var.service}-pub-${local.env}" : "${var.name_prefix}-${var.service}-pub-${local.env}"
  tg_port             = var.tg_port == "" ? var.listener_port : var.tg_port
  dns_zone            = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  security_group_name = var.security_group_name == "" ? local.alb_name : var.security_group_name
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    NetworkType         = "public"
    Service             = var.service
  }
}
