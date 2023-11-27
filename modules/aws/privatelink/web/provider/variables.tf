variable "service" {
  description = "unique service name for project/application"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "name_prefix" {
  description = "name prefix for security group"
  default     = ""
}

variable "cname_subdomain_alb" {
  description = "custom cname subdomain to use for privatelink private DNS"
  default     = ""
}

variable "port" {
  description = "TCP port to allow services on the consumer VPC to access services on the provider VPC"
  default     = 443
}

locals {
  env              = "${var.env}${var.env_inst}"
  cname            = var.name_prefix == "" ? "${var.service}-pvtlnk" : "${var.name_prefix}-${var.service}-pvtlnk"
  private_dns_name = var.cname_subdomain_alb != "" ? var.cname_subdomain_alb : "${var.service}.${local.dns_zone}"
  dns_zone         = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  name             = var.name_prefix == "" ? "${var.service}-pvtlnk-${local.env}" : "${var.name_prefix}-${var.service}-pvtlnk-${local.env}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = "Terraform"
    Service             = var.service
  }
}
