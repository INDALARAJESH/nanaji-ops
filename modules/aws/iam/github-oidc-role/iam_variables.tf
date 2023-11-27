variable "repository_name" {
  description = "Required. Github repository name, used in resource name interpolations"
  type        = string
}

variable "oidc_provider_arn" {
  description = "Required. AWS ARN for the required openid_connect_provider resource"
  type        = string
}

variable "policy_document" {
  description = "Required. JSON of aws_iam_policy_document to allow (defaults to implicit deny all)"
  type        = string
}

variable "oidc_subject" {
  description = "Optional. GitHub OIDC subject to allow, should include the subject type like environment or ref as a prefix. Defaults to *, which allows all workflows from the repository."
  type        = string
  default     = "*"
}

variable "iam_role_name_suffix" {
  description = "Optional. Custom suffix used at the end of IAM resource name interpolations. Eg: `service-foo-development`. Defaults to repository_name if missing."
  type        = string
  default     = null
}
