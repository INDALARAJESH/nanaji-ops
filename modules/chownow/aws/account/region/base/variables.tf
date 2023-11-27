variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain used for DNS"
  default     = "chownow.com"
}

variable "domain_chownowapi" {
  description = "domain used for DNS"
  default     = "chownowapi.com"
}

variable "domain_chownowcdn" {
  description = "domain used for DNS"
  default     = "chownowcdn.com"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "build_dns_zone_name" {
  description = "build dns zone name from env and domain variables, otherwise use domain variable"
  default     = 1
}

locals {
  env                 = "${var.env}${var.env_inst}"
  dns_zone            = var.build_dns_zone_name == 1 ? "${local.env}.svpn.${var.domain}" : var.domain
  dns_zone_chownowapi = local.env == "ncp" ? var.domain_chownowapi : "${local.env}.${var.domain_chownowapi}"
  dns_zone_chownowcdn = local.env == "prod" ? var.domain_chownowcdn : "${local.env}.${var.domain_chownowcdn}"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    ManagedBy           = var.tag_managed_by
  }

  extra_tags = {
    TFModule = "ops-tf-modules/modules/chownow/aws/account/region/base"
  }
}
