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

variable "sqs_queue_name" {
  description = "name of sqs queue. You must pass in the sqs_queue_name output from sqs module"
}

variable "lambda_function_arn" {
  description = "arn of recipient lambda function"
}

variable "lambda_iam_role_id" {
  description = "id of lambda iam role"
}

variable "mapping_batch_size" {
  description = "size of message batch to pass to lambda"
  default     = 10
}

variable "maximum_batching_window_in_seconds" {
  description = "max wait seconds to assemble batch"
  default     = 5
}

variable "function_response_types" {
  description = "A list of current response type enums applied to the event source mapping for AWS Lambda checkpointing"
  default     = []
}

variable "maximum_concurrency" {
  description = "Limits the number of concurrent instances that the event source can invoke. Must be between 2 and 1000"
  default     = null
}

locals {
  env = "${var.env}${var.env_inst}"
  common_tags = {
    Environment         = local.env,
    EnvironmentInstance = var.env_inst,
    Service             = var.service,
    ManagedBy           = var.tag_managed_by
  }
}
