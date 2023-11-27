variable "name" {
  description = "unique name"
  default     = "facebook"
}

variable "service" {
  description = "unique service name"
  default     = "integration"
}

variable "api_gateway_name" {
  description = "Name of REST API gateway"
  default     = "channels"
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
  default     = "channels"
}

variable "lambda_image_uri" {
  description = "lambda ECR image URI"
  default     = ""
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "cloudflare_domain" {
  description = "cloudflare dns domain"
  default     = "cdn.cloudflare.net"
}

locals {
  env                   = "${var.env}${var.env_inst}"
  app_name              = "${lower(var.name)}-${lower(var.service)}"
  domain_name           = local.env == "ncp" ? var.domain_name : "${local.env}.${var.domain_name}"
  table_name            = "${var.name}-dynamodb-${local.env}"
  lambda_classification = "${local.app_name}_${local.env}"

  extra_tags = {
    TFModule = "modules/chownow/services/facebook-business-integration/base"
  }
}
