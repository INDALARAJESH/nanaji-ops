variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name"
  default     = "pritunl"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "vpc_name" {
  description = "name of vpc for resource placement"
}

variable "mongodb_instances" {
  description = "mongodb name, instance size, and subnet id"
}

variable "dns_zone" {
  description = "private dns zone for record creation"
}

locals {
  env                         = "${var.env}${var.env_inst}"
  name                        = "${var.service}-mongodb-${local.env}"
  dd_api_key_secret_name      = "${local.env}/${var.service}/dd_api_key"
  threatstack_key_secret_name = "${local.env}/${var.service}/threatstack_key"

  env_inst_tag = var.env_inst == "" ? {} : { "EnvironmentInstance" = var.env_inst }
  common_tags = merge({
    Environment = local.env
    ManagedBy   = var.tag_managed_by
    Name        = local.name
    Service     = var.service
    VPC         = var.vpc_name
  }, local.env_inst_tag)
}
