variable "service" {
  description = "unique service name"
  default     = "hermosa"
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

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "svpn_subdomain" {
  description = "subdomain name to use for resource creation"
  default     = "svpn"
}

variable "domain" {
  description = "domain name to use for resource creation"
  default     = "chownow.com"
}

variable "custom_chownowcdn_zone" {
  description = "customizable chownowcdn zone name"
  default     = ""
}

variable "custom_cert_chownowcdn_domain" {
  description = "customizable SSL cert chownowcdn domain name"
  default     = ""
}

variable "custom_username" {
  description = "custom name for hermosa IAM user"
  default     = ""
}

variable "custom_username_path" {
  description = "custom path for hermosa IAM user"
  default     = ""
}

locals {
  env                    = "${var.env}${var.env_inst}"
  name_prefix            = "${var.bucket_name_prefix}${var.service}"
  certificate_domain     = var.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  dns_zone               = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  vpc_name               = var.custom_vpc_name != "" ? var.custom_vpc_name : "${var.vpc_name_prefix}-${local.env}"
  region                 = data.aws_region.current.name
  account_id             = data.aws_caller_identity.current.account_id
  chownowcdn_zone        = var.custom_chownowcdn_zone != "" ? var.custom_chownowcdn_zone : "${local.env}.chownowcdn.com"
  cert_chownowcdn_domain = var.custom_cert_chownowcdn_domain != "" ? var.custom_cert_chownowcdn_domain : local.chownowcdn_zone
  custom_username        = var.custom_username != "" ? var.custom_username : "${local.name_prefix}-user-${local.env}"
  custom_username_path   = var.custom_username_path != "" ? var.custom_username_path : "/${local.env}/${var.service}/users/"
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }
}
