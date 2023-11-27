variable "service" {
  description = "name of service"
  default     = "jumpbox"
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

locals {
  env           = "${var.env}${var.env_inst}"
  name          = "jumpbox-${local.env}"
  teleport_name = "teleport-${local.env}"

  env_inst_tag = var.env_inst == "" ? {} : map("EnvironmentInstance", var.env_inst, )
  common_tags = merge({
    Environment = local.env
    ManagedBy   = var.tag_managed_by
    Name        = local.name
    Service     = var.service
  }, local.env_inst_tag)
}
