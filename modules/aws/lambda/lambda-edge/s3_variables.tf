variable "bucket_prefix" {
  description = "prefix for s3 bucket name"
  default     = "cn-"
}

variable "s3_sse_algorithm" {
  description = "encryption algorithm used for s3 bucket"
  default     = "AES256"
}

variable "s3_acl" {
  description = "acl type for s3 bucket"
  default     = "private"
}
