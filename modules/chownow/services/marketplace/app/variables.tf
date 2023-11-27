variable "name" {
  description = "short name of app"
  default     = "marketplace"
}

variable "service" {
  description = "name of app/service"
  default     = "marketplace"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "frontend"
}

variable "custom_vpc_name" {
  description = "overrides default vpc for resource placement"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "svpn_subdomain" {
  description = "subdomain name to use for resource creation"
  default     = "svpn"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "nc"
}

locals {
  env                 = "${var.env}${var.env_inst}"
  dns_zone            = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  security_group_name = local.env == "prod" ? "vpn_web-${local.env}" : "${var.vpc_name_prefix}-vpn-sg-${local.env}"
  aws_acm_certificate = local.env == "prod" ? var.domain : "${var.wildcard_domain_prefix}${local.env}.svpn.${var.domain}"
  vpc_name            = var.custom_vpc_name != "" ? var.custom_vpc_name : "${var.vpc_name_prefix}-${local.env}"
  aws_account_id      = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name

  common_tags = merge(
    {
      Environment = local.env
      ManagedBy   = var.tag_managed_by
      VPC         = local.vpc_name
      Service     = var.service
      TFModule    = "modules/chownow/services/marketplace/app"
      Owner       = "frontend"
    },
    var.env_inst != "" ? { "EnvironmentInstance" = var.env_inst } : { "EnvironmentInstance" = null }
  )
}
