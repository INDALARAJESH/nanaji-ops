variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name"
  default     = "security-patch-manager"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "environment_tag_list" {
  description = "an optional override to consolidate the patching of multiple enns in a single AWS account"
  default     = []
}

locals {
  env         = "${var.env}${var.env_inst}"
  name        = "amazon-linux-2-${local.env}"
  notify_list = ["ops+${local.env}@chownow.com"]

  target_values = var.environment_tag_list == [] ? [local.env] : var.environment_tag_list

  env_inst_tag = var.env_inst == "" ? {} : { "EnvironmentInstance" = var.env_inst }
  common_tags = merge({
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }, local.env_inst_tag)
}
