variable "mul_notifications_slack_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.8"
}

variable "mul_notifications_slack_name" {
  description = "lambda name"
  default     = "mulholland-notifications-slack"
}

variable "mul_notifications_slack_image_uri" {
  description = "lambda ECR image URI"
  default     = ""
}

variable "mul_notifications_slack_s3" {
  description = "boolean for enabling s3 artifacts for lambda"
  default     = false
}

variable "mul_notifications_slack_ecr" {
  description = "boolean for enabling ecr artifacts for lambda"
  default     = true
}

variable "mul_notifications_slack_memory_size" {
  description = "lambda memory allocation"
  default     = 128
}

variable "mul_notifications_slack_cron" {
  description = "boolean for enabling lambda cron"
  default     = false
}

locals {
  mul_notifications_slack_env_vars = {
    ENV         = local.env
    SLACK_HOOKS = "${local.env}/${var.service}/slack-hooks"
  }
}
