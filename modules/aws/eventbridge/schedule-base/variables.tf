variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
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
  env = "${var.env}${var.env_inst}"

  target_sqs_queue_name = "${var.target_sqs_queue_name}_${local.env}"
  scheduler_role_name   = "${var.service}-role_${local.env}"
  schedule_group_name   = "${var.service}-group_${local.env}"
  policy_name           = "${var.service}-policy-${local.env}"

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
