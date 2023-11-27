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
  env = "${var.env}${var.env_inst}"

  tg_name = var.target_group_name != "" ? var.target_group_name : var.name_suffix == "" ? "${var.alb_name}-${lower(var.tg_port)}" : "${var.alb_name}-${lower(var.tg_port)}-${var.name_suffix}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }
}
