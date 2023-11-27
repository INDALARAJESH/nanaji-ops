variable "log_group_path" {
  description = "path for logs prior to service name"
  default     = "/aws/eventbridge"
}

variable "custom_log_group_name" {
  description = "custom name if needed for aurora audit log group"
  default     = ""
}

locals {
  log_group_name = var.custom_log_group_name != "" ? var.custom_log_group_name : "${var.log_group_path}/${var.service}-${local.env}-logs"
}
