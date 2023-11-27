variable "env" {
  description = "AWS account to deploy to"
}

variable "env_inst" {
  description = "Environment instance to deploy to"
  default     = ""
}

variable "service" {
  description = "The unique service name"
  default     = "restaurant-search"
}

variable "vpc_name" {
  description = "Name of VPC to use when running task"
}

variable "lookback_time_frame" {
  description = "number of hours to backfill"
  default     = "2"
}

variable "rule_frequency" {
  description = "frequency that eventbridge rule should trigger the task. in hours"
  default     = "1"
}

variable "cross_account_identifiers" {
  description = "List of root account ARNs to grant access to eventbridge rules"
  default     = []
}

locals {
  # Overwrite global env_inst to ensure we don't pass an empty string to AWS
  tag_env_inst = var.env_inst == "" ? " " : var.env_inst
  env          = "${var.env}${var.env_inst}"
}
