variable "service" {
  description = "unique/short service name"
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance"
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

variable "sns_topic_arn" {
  description = "ARN of topic to subscribe to"
}

variable "sqs_queue_arn" {
  description = "ARN of sqs queue to send to"
}

variable "raw_message_delivery" {
  description = "deliver the raw sns message to the queue"
  default     = true
}

locals {
  env = "${var.env}${var.env_inst}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = var.service
  }
}

variable "filter_policy" {
  description = "filter policy json for a given subscription"
  default     = ""
}
