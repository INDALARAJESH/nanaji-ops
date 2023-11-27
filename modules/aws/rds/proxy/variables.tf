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

locals {
  env     = format("%s%s", var.env, var.env_inst)
  name    = format("%s-proxy-%s", var.service, local.env)
  rw_name = format("%s-rw-%s", var.service, local.env)
  ro_name = format("%s-ro-%s", var.service, local.env)

  common_tags = {
    "Environment" = local.env
    "Service"     = var.service
    "ManagedBy"   = var.tag_managed_by
    "VPC"         = format("%s-%s", var.vpc_name_prefix, local.env)
  }
}

