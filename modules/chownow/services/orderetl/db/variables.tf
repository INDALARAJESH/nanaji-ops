variable "service" {
  description = "unique service name"
  default     = "orderetl"
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
  default     = "DataEng"
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

variable "service_family" {
  description = "unique service family name"
  default     = "DataEngETL"
}

locals {
  env      = "${var.env}${var.env_inst}"
  name     = "${var.service}-${var.db_name_suffix}-${local.env}"
  vpc_name = var.custom_vpc_name == "" ? "${var.vpc_name_prefix}-${local.env}" : var.custom_vpc_name


  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
    ServiceFamily       = var.service_family
    TFModule            = "ops-tf-modules/modules/chownow/services/${var.service}/base"
    VPC                 = local.vpc_name
  }
}
