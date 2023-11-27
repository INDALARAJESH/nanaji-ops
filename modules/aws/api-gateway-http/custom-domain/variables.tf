variable "domain" {
  description = "Domain name"
}

variable "subdomain" {
  description = "Subdomain name"
  default     = ""
}

variable "api_gateway_id" {
  description = "API Gateway id"
}

variable "api_gateway_stage_id" {
  description = "API Gateway stage_id"
}

locals {
  domain_name = var.subdomain == "" ? var.domain : "${var.subdomain}.${var.domain}"
}
