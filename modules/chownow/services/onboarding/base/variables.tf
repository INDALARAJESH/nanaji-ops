variable "name" {
  description = "unique name"
  default     = "self-service"
}

variable "service" {
  description = "unique service name"
  default     = "onboarding"
}

variable "env" {
  description = "unique environment name"
  default     = "dev"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain_name" {
  description = "DNS domain name"
  default     = "chownowapi.com"
}

variable "subdomain_name" {
  description = "DNS subdomain name"
  default     = ""
}

variable "tag_managed_by" {
  description = "What created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}


locals {
  env      = "${var.env}${var.env_inst}"
  app_name = format("%s-%s", lower(var.name), lower(var.service))

  domain_name                = local.env == "ncp" ? var.domain_name : "${local.env}.${var.domain_name}"
  service_domain_name        = "onboarding.${local.domain_name}"
  service_origin_domain_name = "onboarding-origin.${local.domain_name}"
  domain_names = var.subdomain_name == "" ? [] : [
    format("%s.%s", var.subdomain_name, local.domain_name),
  ]

  common_tags = {
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }

  extra_tags = {
    TFModule = "ops-tf-modules/modules/chownow/services/onboarding/base" # Required for some base modules
  }
}
