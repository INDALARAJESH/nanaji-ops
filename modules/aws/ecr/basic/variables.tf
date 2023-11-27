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

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "image_tag_is_mutable" {
  description = "The tag mutability setting for the repository"
  default     = true
}

locals {
  env                  = "${var.env}${var.env_inst}"
  name                 = var.custom_name != "" ? var.custom_name : "${var.service}-${local.env}"
  image_tag_mutability = var.image_tag_is_mutable ? "MUTABLE" : "IMMUTABLE"

  ecr_policy = data.aws_iam_policy_document.default_ecr_policy.json

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }
}
