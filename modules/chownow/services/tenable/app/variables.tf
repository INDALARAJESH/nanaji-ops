variable "env" {
  description = "unique environment/stage name"
  default     = ""
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "tenable"
}

variable "domain_name" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "vpc_name" {
  description = "vpc name to deploy resources"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "Devops"
}

locals {
  env           = "${var.env}${var.env_inst}"
  region        = data.aws_region.current.name
  dns_zone_name = "${local.env}.aws.${var.domain_name}"
  ami_id        = var.ami_id != "" ? var.ami_id : data.aws_ami.nessus.image_id

  enable_internal_allow = var.vpc_name == local.env ? 1 : 0
  internal_allow_sg     = local.enable_internal_allow == 1 ? [data.aws_security_group.internal_allow[0].id] : []

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
  }
}
