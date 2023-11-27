#####################
# General Variables #
#####################

variable "s3_key_prefix" {
  description = "s3 key prefix"
  default     = "logs"
}


####################
# Syslog Variables #
####################

variable "s3_object_lock_configuration_status" {
  default = "Enabled"
}

variable "s3_object_lock_configuration_mode" {
  description = "Governance = Permissions allow to remove OL, Compliance = can't remove OL"
  default     = "GOVERNANCE"
}

variable "s3_object_lock_configuration_days" {
  default = 365
}



########################
# Cloudtrail Variables #
########################

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
