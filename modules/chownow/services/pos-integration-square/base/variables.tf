variable "name" {
  description = "unique name"
  default     = "pos-square"
}

variable "service" {
  description = "unique service name"
  default     = "integration"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to launch databases in"
}

variable "api_gateway_name" {
  description = "Name of REST API gateway"
  default     = "pos-square"
}

variable "cors_allow_origins" {
  description = "comma separated list of allowed CORS origins"
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
  env                   = format("%s%s", var.env, var.env_inst)
  app_name              = format("%s-%s", lower(var.name), lower(var.service))
  domain_name           = local.env == "ncp" ? var.domain_name : format("%s.%s", local.env, var.domain_name)
  lambda_classification = format("%s-%s", local.app_name, local.env)

  service      = var.service

  common_tags = {
    Service             = var.name
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }
  extra_tags = {
    TFModule = "modules/chownow/services/pos-integration-square/base"
  }
}
