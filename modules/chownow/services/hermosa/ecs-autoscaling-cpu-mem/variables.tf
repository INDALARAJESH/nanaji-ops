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

variable "average_cpu_utilization" {
  description = "average cpu utilization target"
  default     = "70"
}

variable "average_memory_utilization" {
  description = "average cpu utilization target"
  default     = "70"
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  region         = data.aws_region.current.name
  env            = "${var.env}${var.env_inst}"
}
