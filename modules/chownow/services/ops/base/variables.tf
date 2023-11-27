variable "service" {
  description = "unique service name"
  default     = "ops-alb"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env         = "${var.env}${var.env_inst}"
  vpc_name    = "ops"
  svpn_domain = "${local.env}.svpn.${local.domain}"
  domain      = "chownow.com"
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = "Terraform"
    Service             = var.service
  }
}
