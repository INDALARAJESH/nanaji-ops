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

variable "domain_chownowcdn" {
  description = "domain used for DNS"
  default     = "chownowcdn.com"
}

variable "domain_chownowapi" {
  description = "domain used for DNS"
  default     = "chownowapi.com"
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
  env                = "${var.env}${var.env_inst}"
  public_svpn_domain = "${local.env}.svpn.${var.domain}"
  chownowcdn_domain  = "${local.env}.${var.domain_chownowcdn}"
  chownowapi_domain  = "${local.env}.${var.domain_chownowapi}"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    ManagedBy           = var.tag_managed_by
  }
}
