variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of service"
  default     = "hermosa"
}

variable "retention_in_days" {
  description = "days to retain log events. 0 means forever."
  default     = 90
}

variable "enable_execute_command_logging" {
  description = "enable logging of execute command sessions to cloudwatch and S3"
  default     = false
}

locals {
  env          = "${var.env}${var.env_inst}"
  cluster_name = "${var.service}-${local.env}"
  bucket_name  = "cn-aws-ssm-${local.cluster_name}-ecs-execute-command-logs"
}
