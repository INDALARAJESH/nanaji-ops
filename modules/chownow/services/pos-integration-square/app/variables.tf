variable "name" {
  description = "unique name"
  default     = "pos-square"
}

variable "service" {
  description = "unique service name"
  default     = "integration"
}

variable "domain_name" {
  description = "DNS domain name"
  default     = "chownowapi.com"
}

variable "subdomain_name" {
  description = "DNS subdomain name"
  default     = "pos-square"
}

variable "vpc_name_prefix" {
  description = "vpc name prefix to launch databases in"
}

variable "cors_allow_origins" {
  description = "comma separated list of allowed CORS origins"
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

variable "hermosa_custom_vpc_name" {
  description = "custom vpc name for resources to be created inside"
  default     = ""
}

locals {
  env      = format("%s%s", var.env, var.env_inst)
  app_name = format("%s-%s", lower(var.name), lower(var.service))
  service  = format("%s-%s", lower(var.name), lower(var.service))
  hermosa_apigw = format("hermosa-apigw-%s",  lower(local.env))
  hermosa_vpc_name = var.hermosa_custom_vpc_name == "" ? "main-${local.env}" : var.hermosa_custom_vpc_name
  domain_name = local.env == "ncp" ? var.domain_name : format("%s.%s", local.env, var.domain_name)
  domain_names = var.subdomain_name == "" ? [] : [
    format("%s.%s", var.subdomain_name, local.domain_name),
  ]

  key_id = format("alias/cn-%s-cmk-%s-%s", local.app_name, var.env, data.aws_region.current.name)

  cors_allow_origins_lower = format("https://admin.%s.chownow.com,https://web.%s.chownow.com:3000,https://app-marketplace.%s.svpn.chownow.com,https://app-order-direct.%s.svpn.chownow.com,https://admin.%s.svpn.chownow.com", local.env, local.env, local.env, local.env, local.env)
  cors_allow_origins_prod  = "https://admin.chownow.com,https://dashboard.chownow.com,https://direct.chownow.com,https://eat.chownow.com,https://order.chownow.com,https://ordering.chownow.com,https://web.chownow.com"
  cors_allow_origins       = local.env == "ncp" ? local.cors_allow_origins_prod : local.cors_allow_origins_lower

  access_log_settings = [{
    destination_arn = format("arn:aws:logs:us-east-1:%s:log-group:/aws/api-gateway/pos-square-integration-log-group-%s", data.aws_caller_identity.current.account_id, local.env)
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "resourcePath" : "$context.resourcePath", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength", "userAgent" : "$context.identity.userAgent", "integrationError" : "$context.integration.error", "sourceIp" : "$context.identity.sourceIp", "routeKey" : "$context.routeKey", "path" : "$context.path", "service" : "pos-square-apigateway"
 })
  }]

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
