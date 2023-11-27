variable "service" {
  description = "unique service name"
  default     = "hermosa"
}

variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "custom_vpc_name" {
  description = "custom vpc name"
  default     = ""
}

variable "enable_vpc_options" {
  description = "option to use vpc_options"
  default     = 0
}

locals {
  env      = "${var.env}${var.env_inst}"
  name     = "hermosa-es-${local.env}"
  vpc_name = var.custom_vpc_name != "" ? var.custom_vpc_name : "main-${local.env}"
  vpc_options = var.enable_vpc_options == 1 ? {
    subnet_ids         = slice(tolist(data.aws_subnet_ids.private.ids), 0, 2)
    security_group_ids = [aws_security_group.es.id]
  } : {}

  vpc_subnet_cidrs = [for s in data.aws_subnet.private : s.cidr_block]

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
    TFModule            = "modules/chownow/services/hermosa/es"
  }
}
