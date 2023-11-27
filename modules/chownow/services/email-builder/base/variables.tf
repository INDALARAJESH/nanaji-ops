variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
  default     = "email-builder"
}

variable "emailbuilder_name" {
  description = "emailbuilder url for CORS"
  default     = "emailbuilder"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "frontend"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "nc"
}

variable "custom_vpc_name" {
  description = "overrides default vpc for resource placement"
  default     = ""
}

variable "domain_chownowcdn" {
  description = "default domain name for record placement"
  default     = "chownowcdn.com"
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "svpn_subdomain" {
  description = "subdomain name to use for resource creation"
  default     = "svpn"
}

variable "cloudflare_allow_ips" {
  type = list(any)

  default = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
  ]
}

locals {
  env                = "${var.env}${var.env_inst}"
  bucket_name        = local.env == "ncp" ? "emailbuilder.chownowcdn.com" : "emailbuilder.${local.env}.chownowcdn.com"
  dns_zone           = local.env == "ncp" ? var.domain : "${local.env}.svpn.${var.domain}"
  vpc_name           = var.custom_vpc_name != "" ? var.custom_vpc_name : "${var.vpc_name_prefix}-${local.env}"
  environment_domain = "${local.env}.${var.domain_chownowcdn}"

  # define is_not_prod here to allow conditional data source to work
  is_not_prod = local.env != "ncp" ? 1 : 0

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
