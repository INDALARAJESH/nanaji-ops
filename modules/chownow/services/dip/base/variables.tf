variable "service" {
  description = "unique service name"
  default     = "dip"
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

variable "tag_tfmodule" {
  description = "path to terraform module location"
  default     = "ops-tf-modules/modules/chownow/services/dip/base"
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

variable "custom_vpc_name" {
  description = "overrides default vpc for resource placement"
  default     = ""
}

locals {
  env      = "${var.env}${var.env_inst}"
  vpc_name = var.custom_vpc_name != "" ? var.custom_vpc_name : "main-${local.env}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
    VPC                 = local.vpc_name
  }
}
