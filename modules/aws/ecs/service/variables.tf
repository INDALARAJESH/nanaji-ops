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

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env              = "${var.env}${var.env_inst}"
  service          = var.service_role == "" ? var.service : "${var.service}-${var.service_role}"
  ecs_service_name = var.custom_ecs_service_name != "" ? var.custom_ecs_service_name : "${local.service}-${local.env}"

  env_inst_tag = var.env_inst == "" ? {} : { "EnvironmentInstance" = var.env_inst }
  common_tags = merge({
    Environment = local.env,
    Service     = local.service,
    ManagedBy   = var.tag_managed_by
  }, local.env_inst_tag)
}