variable "name_prefix" {
  description = "s3 bucket name prefix"
  default     = "cn"
}

variable "bucket_acl" {
  description = "bucket acl"
  default     = "private"
}

variable "sse_algorithm" {
  description = "encryption algorith"
  default     = "AES256"
}

variable "s3_lifecycle_rule_enabled" {
  description = "s3 lifecycle rule enabled"
  default     = true
}

variable "transition_days" {
  description = "transition object after x days"
  default     = "93"
}

variable "transition_storage_class" {
  description = "storage class for transitioned objects"
  default     = "DEEP_ARCHIVE"
}

variable "object_expiration" {
  description = "objects expire/delete after x days"
  default     = "366"
}

variable "abort_incomplete_days" {
  description = "remove incomplete files in x days"
  default     = "30"
}
