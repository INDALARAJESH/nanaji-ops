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

variable "custom_vpc_name" {
  description = "vpc override for resource placement"
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

locals {
  env      = "${var.env}${var.env_inst}"
  name     = "${var.service}-postgres-${local.env}"
  vpc_name = var.custom_vpc_name != "" ? var.custom_vpc_name : "${var.vpc_name_prefix}-${local.env}"

  common_tags = {
    "Environment" = local.env
    "Service"     = var.service
    "ManagedBy"   = var.tag_managed_by
    "VPC"         = local.vpc_name
  }
}

