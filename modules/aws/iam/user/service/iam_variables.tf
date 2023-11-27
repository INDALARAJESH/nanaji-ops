variable "name_prefix" {
  description = "service account name prefix"
  default     = "svc"
}

variable "user_policy" {
  description = "rendered iam user policy"
}
