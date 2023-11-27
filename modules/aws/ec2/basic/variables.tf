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
  description = "domain name for instance dns"
  default     = "chownow.com"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix for resource placement"
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
  dns_zone_private = "${local.env}.aws.${var.domain}"
  dns_zone_public  = var.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  vpc_name         = var.custom_vpc_name == "" ? "${var.vpc_name_prefix}-${local.env}" : var.custom_vpc_name

  env_inst_tag = var.env_inst == "" ? {} : { "EnvironmentInstance" = var.env_inst }
  common_tags = merge({
    Environment = local.env
    ManagedBy   = var.tag_managed_by
    ServerGroup = local.server_group
    Service     = var.service
    VPC         = local.vpc_name
  }, local.env_inst_tag)
}
