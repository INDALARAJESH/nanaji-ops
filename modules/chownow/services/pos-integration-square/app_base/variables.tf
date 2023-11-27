variable "name" {
  description = "unique name"
  default     = "pos-square"
}

variable "service" {
  description = "unique service name"
  default     = "integration"
}

variable "custom_domain_name" {
  description = "DNS domain name"
  default     = ""
}

variable "subdomain_name" {
  description = "DNS subdomain name"
  default     = "pos-square"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to launch databases in"
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

locals {
  env      = format("%s%s", var.env, var.env_inst)
  app_name = format("%s-%s", lower(var.name), lower(var.service))
  service  = format("%s-%s", lower(var.name), lower(var.service))
  api_domain_name = "chownowapi.com"
  
  domain_name = var.custom_domain_name == "" ? format("%s.%s", local.env, local.api_domain_name) : var.custom_domain_name
  domain_names = var.subdomain_name == "" ? [] : [
    format("%s.%s", var.subdomain_name, local.domain_name),
  ]

  key_id = format("alias/cn-%s-cmk-%s-%s", local.app_name, var.env, data.aws_region.current.name)

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.name
  }

  extra_tags = {
    TFModule = "modules/chownow/services/pos-integration-square/app"
  }
}
