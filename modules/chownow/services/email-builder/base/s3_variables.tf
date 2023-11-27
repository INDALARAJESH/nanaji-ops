variable "bucket_name_prefix" {
  description = "s3 bucket name prefix"
  default     = "cn-"
}

variable "enable_bucket_static_assets" {
  description = "enable/disable bucket creation"
  default     = 1
}

locals {
  bucket_static_assets = "${var.bucket_name_prefix}${var.service}-static-assets-${local.env}"
}
