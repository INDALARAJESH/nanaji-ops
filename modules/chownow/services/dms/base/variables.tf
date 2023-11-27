variable "service" {
  description = "name of app/service"
  default     = "dms"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "nc"
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
  env      = "${var.env}${var.env_inst}"
  dns_zone = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"

  vpc_name = "${var.vpc_name_prefix}-${local.env}"

  bucket_name     = "cn-mds-files-${local.env}"
  allowed_origins = []

  env_inst_tag = var.env_inst == "" ? {} : tomap("EnvironmentInstance", var.env_inst, )
  common_tags = merge(map(
    "Environment", var.env,
    "ManagedBy", var.tag_managed_by,
    "Service", var.service,
  ), local.env_inst_tag)
}
