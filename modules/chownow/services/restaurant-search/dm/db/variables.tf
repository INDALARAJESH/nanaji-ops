variable "service" {
  description = "unique service name"
  default     = "restaurant-search-dm"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "tag_owner" {
  description = "The team which owns these resources"
  default     = "chefs_toys"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "svpn_subdomain" {
  description = "subdomain name to use for resource creation"
  default     = "svpn"
}

variable "domain" {
  description = "domain name to use for resource creation"
  default     = "chownow.com"
}

variable "vpc_name_prefix" {
  description = "VPC name which is used to determine where to create resources"
  default     = "main"
}

variable "custom_vpc_name" {
  description = "option to override destination vpc"
  default     = ""
}


locals {
  env      = "${var.env}${var.env_inst}"
  vpc_name = var.custom_vpc_name == "" ? "${var.vpc_name_prefix}-${local.env}" : var.custom_vpc_name

  # database
  name = "${var.service}-${var.db_name_suffix}-${local.env}"

  # Private subnet blocks
  vpc_private_subnet_cidrs = [for s in data.aws_subnet.private : s.cidr_block]


  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
    TFModule            = "ops-tf-modules/modules/chownow/services/restaurant-search/dm/db"
    VPC                 = local.vpc_name
  }
}
