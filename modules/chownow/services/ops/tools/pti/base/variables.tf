variable "service" {
  description = "unique service name for project/application"
  default     = "pti"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name for instance dns"
  default     = "chownow.com"
}

variable "vpc_name" {
  description = "vpc name prefix for resource placement"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "tag_tfmodule" {
  description = "terraform module path"
  default     = "ops-tf-modules/modules/chownow/ops/tools/pti/base"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "custom_vpc_name" {
  description = "alternate vpc to place resources in"
  default     = ""
}

locals {
  env              = "${var.env}${var.env_inst}"
  dns_zone_private = "${local.env}.aws.${var.domain}"
  dns_zone_public  = var.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  name             = "${var.service}-${var.vpc_name}"

  env_inst_tag = var.env_inst == "" ? {} : tomap({ "EnvironmentInstance" = var.env_inst })
  common_tags = merge({
    Environment = local.env
    ManagedBy   = var.tag_managed_by
    TFModule    = var.tag_tfmodule
    Service     = var.service
    VPC         = var.vpc_name
  }, local.env_inst_tag)
}
