variable "name" {
  description = "unique name"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}


variable "service" {
  description = "unique service name for project/application"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "iam_sqs_arns" {
  description = "(optional) list of sqs queues arns to r/w access by state machine"
  default     = []
}

locals {
  env = format("%s%s", var.env, var.env_inst)

  common_tags = {
    "Environment" = local.env,
    "Service"     = var.service,
    "ManagedBy"   = var.tag_managed_by,
  }
}
