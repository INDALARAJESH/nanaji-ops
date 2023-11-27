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
  env                     = "${var.env}${var.env_inst}"
  sqs_queue_name          = var.fifo_queue ? "${var.sqs_queue_name}_${var.env}${var.env_inst}.fifo" : "${var.sqs_queue_name}_${var.env}${var.env_inst}"
  has_custom_queue_policy = var.custom_queue_policy_json != null

  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
