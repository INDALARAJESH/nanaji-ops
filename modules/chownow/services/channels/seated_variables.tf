variable "enable_seated_external" {
  description = "boolean toggle to create seated resources"
  default     = false
}

variable "enable_seated" {
  description = "boolean toggle to create seated resources"
  default     = true
}

variable "cn_seated_s3_bucket_name" {
  description = "name of ChowNow S3 bucket for internal testing in the lower environments"
  default     = ""
}

locals {
  seated_s3_bucket_name    = "seated-chownow"
  cn_seated_s3_bucket_name = var.cn_seated_s3_bucket_name == "" ? "cn-${var.service}-seated-${local.env}" : var.cn_seated_s3_bucket_name
}
