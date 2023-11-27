variable "service" {
  description = "name of service"
  default     = "pritunl"
}

variable "env" {
  description = "unique environment name"
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
  description = "the team which owns these resources"
  default     = "Ops"
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "pritunl"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

locals {
  env                         = "${var.env}${var.env_inst}"
  name                        = "${var.service}-app-${local.env}"
  dns_zone                    = "${local.env}.svpn.${var.domain}"
  bucket_name                 = "cn-${var.service}-data-${local.env}"
  vpc_name                    = "${var.vpc_name_prefix}-${local.env}"
  dd_api_key_secret_name      = "${local.env}/${var.service}/dd_api_key"
  threatstack_key_secret_name = "${local.env}/${var.service}/threatstack_key"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
    VPC                 = local.vpc_name
  }
}

