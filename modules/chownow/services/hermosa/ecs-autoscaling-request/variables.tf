variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "cluster_name" {
  description = "ECS cluster name"
  default     = ""
}

variable "service_name" {
  description = "full name of ECS service including environment"
  default     = "hermosa-task-dev"
}

variable "alb_name" {
  description = "ALB name to track request count per target"
}

variable "target_group_name" {
  description = "Target group name to track request count"
}

variable "min_count" {
  description = "min number of task instances to run"
  default     = 1
}

variable "max_count" {
  description = "max number of task instances to run"
  default     = 20
}

variable "policy_scale_in_cooldown" {
  description = "the amount of time (in seconds) to wait until the next scaling event"
  default     = 300
}

variable "request_count_per_target" {
  description = "targeted request counts per target (task instance in the target group)"
  default     = 700
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  region         = data.aws_region.current.name
  env            = "${var.env}${var.env_inst}"
}
