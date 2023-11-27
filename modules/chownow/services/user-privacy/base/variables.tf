variable "service" {
  description = "unique service name"
  default     = "user-privacy"
}

variable "env" {
  description = "unique environment name"
  default     = "dev"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "What created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "domain_name" {
  description = "DNS domain name"
  default     = "chownowapi.com"
}

variable "subdomain_name" {
  description = "DNS subdomain name"
  default     = ""
}

variable "custom_domain_url" {
  description = "custom domain url"
  default     = ""
}

locals {
  env         = "${var.env}${var.env_inst}"
  app_name    = lower(var.service)
  domain_name = local.env == "ncp" ? var.domain_name : "${local.env}.${var.domain_name}"
  domain_names = var.subdomain_name == "" ? [] : [
    "${var.subdomain_name}.${local.domain_name}",
  ]
  service_domain_name        = "${var.service}.${local.domain_name}"
  service_origin_domain_name = "${var.service}-origin.${local.domain_name}"


  common_tags = {
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }

  extra_tags = {
    TFModule = "ops-tf-modules/modules/chownow/services/user-privacy/base" # Required for some base modules
  }
}
