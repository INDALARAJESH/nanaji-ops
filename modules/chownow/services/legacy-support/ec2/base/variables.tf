variable "service" {
  description = "name of service"
  default     = "legacy-support"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

locals {
  env  = "${var.env}${var.env_inst}"
  name = "${var.service}-${var.env}"

  dd_api_key_secret_name      = "${var.env}/${var.service}/dd_api_key"
  threatstack_key_secret_name = "${var.env}/${var.service}/threatstack_key"

  env_inst_tag = var.env_inst == "" ? {} : map("EnvironmentInstance", var.env_inst, )
  common_tags = merge({
    Environment = local.env
    ManagedBy   = "Terraform"
    Service     = var.service
  }, local.env_inst_tag)
}
