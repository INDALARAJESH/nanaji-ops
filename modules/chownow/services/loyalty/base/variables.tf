variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
  default     = "loyalty"
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
  env          = "${var.env}${var.env_inst}"
  dynamodb_arn = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.table_name}"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
