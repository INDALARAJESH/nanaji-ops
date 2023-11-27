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

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "tag_service_family" {
  description = "required service family tag for given service"
}


locals {
  env                       = "${var.env}${var.env_inst}"
  base_repository_sub       = "repo:ChowNow/${var.repository_name}"
  base_iam_role_name_suffix = var.iam_role_name_suffix == null ? var.repository_name : var.iam_role_name_suffix


  env_inst_tag = var.env_inst == "" ? {} : { "EnvironmentInstance" = var.env_inst }
  common_tags = merge({ "Environment" = var.env
    "ManagedBy" = var.tag_managed_by
  "ServiceFamily" = var.tag_service_family }, local.env_inst_tag)
}
