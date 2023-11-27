variable "permission_set_name" {
  description = "name of the permission set"
  type        = string
}

variable "iam_policy_document_json" {
  description = "IAM policy document's json to include"
  type        = string
}

variable "session_duration" {
  default = "PT8H"
}
