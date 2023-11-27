variable "force_destroy" {
  description = "Indicates whether all objects should be deleted when the bucket is destroyed"
  default     = true
}

variable "object_ownership" {
  description = "Object ownership."
  default     = "BucketOwnerPreferred"
}

variable "acl" {
  description = "Canned ACL to apply to the bucket."
  default     = "private"
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm to use."
  default     = "AES256"
}

variable "versioning_status" {
  description = "Versioning state of the bucket."
  default     = "Disabled"
}

locals {
  bucket_name = var.service
}
