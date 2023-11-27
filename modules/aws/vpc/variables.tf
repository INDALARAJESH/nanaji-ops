variable "env" {
  description = "unique environment/stage name a"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
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
  vpc_name = "${var.vpc_name_prefix}-${local.env}"


  env_inst_tag = var.env_inst == "" ? {} : { "EnvironmentInstance" = var.env_inst }
  common_tags = merge(
    {
      "Environment" = var.env,
      "ManagedBy"   = var.tag_managed_by,
      "VPC"         = "${var.vpc_name_prefix}-${local.env}",
      "VPC_Prefix"  = var.vpc_name_prefix,
    },
  local.env_inst_tag)
}
