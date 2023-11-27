variable "permission_set_name" {
  description = "name of the permission set"
  type        = string
}

variable "iam_policy_arn" {
  description = "arn of the IAM policy to attach"
  type        = string
}

variable "session_duration" {
  default = "PT8H"
}
