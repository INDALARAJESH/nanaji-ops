variable "enable_bucket_cloudfront" {
  description = "Controls if S3 bucket should be created"
  default     = 1
}

locals {
  bucket_cloudfront = "cn-${var.service}-access-logs-${local.env}"
}
