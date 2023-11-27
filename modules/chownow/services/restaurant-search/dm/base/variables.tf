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

variable "tag_tfmodule" {
  description = "folder path for module location"
  default     = "ops-tf-modules/modules/chownow/services/restaurant-search/dm/base"
}
variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
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
  env                                 = "${var.env}${var.env_inst}"
  repl_instance_extra_security_groups = local.vpc_name == var.env ? [data.aws_security_group.internal_legacy[0].id] : []
  vpc_name                            = var.custom_vpc_name == "" ? local.env : var.custom_vpc_name

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Owner               = var.tag_owner
    Service             = var.service
    TFModule            = var.tag_tfmodule
    VPC                 = local.vpc_name
  }
}
