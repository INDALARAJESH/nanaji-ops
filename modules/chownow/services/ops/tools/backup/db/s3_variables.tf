variable "sse_algorithm" {
  description = "encryption algorith"
  default     = "AES256"
}

variable "s3_key_prefix" {
  description = "s3 key prefix to use"
  default     = "services"
}

variable "s3_lifecycle_rule_enabled" {
  description = "s3 lifecycle rule enabled"
  default     = "Enabled"
}

variable "transition_days" {
  description = "transition object after x days"
  default     = "93"
}

variable "transition_storage_class" {
  description = "storage class for transitioned objects"
  default     = "GLACIER"
}

variable "object_expiration" {
  description = "objects expire/delete after x days"
  default     = "366"
}

variable "abort_incomplete_days" {
  description = "remove incomplete files in x days"
  default     = "30"
}
