variable "bucket_name_prefix" {
  description = "s3 bucket name prefix"
  default     = "cn-"
}

variable "enable_bucket_alb_logs" {
  description = "enable/disable bucket creation"
  default     = 1
}

locals {
  bucket_alb_logs          = "${var.bucket_name_prefix}alb-logs-${local.env}"
  alb_logs_transition_days = local.env == "prod" || local.env == "ncp" ? 93 : 33
  alb_logs_expiration_days = local.env == "prod" || local.env == "ncp" ? 366 : 91
}
