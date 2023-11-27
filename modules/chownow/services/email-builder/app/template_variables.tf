# ECS Task Definition Variables
variable "email_builder_log_level" {
  description = "task definition email builder log level environment variable"
  default     = "INFO"
}

variable "image_tag" {
  description = "service image tag"
  default     = "np-cn18383-remove-console-logs"
}

variable "ecr_ops_repo" {
  description = "ops repository address"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com"
}

variable "sentry_dsn" {
  description = "Sentry.io API key"
  default     = "https://d905c9e410ab415391a182c46b90578b@o32006.ingest.sentry.io/6108690"
}


locals {
  ecr_image_repo = "${var.ecr_ops_repo}/${var.service}"
}
