variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to qa01"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "service" {
  description = "unique service name"
}

variable "service_family" {
  description = "unique service family name"
  default     = "SharedInfrastructure"
}

variable "topic_arn" {
  description = "SNS topic ARN"
  default     = ""
}

variable "topic_base_name" {
  description = "SNS topic base name"
}

locals {
  env = "${var.env}${var.env_inst}"

  topic_arn                     = var.topic_arn != "" ? var.topic_arn : data.aws_sns_topic.cn_events[0].arn
  firehose_delivery_stream_name = "${var.topic_base_name}-firehose-stream-${local.env}"
  bucket_name                   = "${var.topic_base_name}-firehose-${local.env}"

  common_tags = {
    Environment         = var.env,
    EnvironmentInstance = var.env_inst,
    Env                 = local.env,
    ManagedBy           = var.tag_managed_by,
    Service             = var.service,
    ServiceFamily       = var.service_family
  }
}
