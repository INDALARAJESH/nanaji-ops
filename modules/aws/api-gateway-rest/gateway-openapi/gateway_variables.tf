variable "openapi_spec_json" {
  description = "JSON-encoded OpenAPI spec with x-amazon-apigateway-integration extensions"
  type        = string
}

variable "resource_policy_enabled" {
  description = "Whether to enable Resource Policy for this API Gateway"
  type        = bool
  default     = false
}

variable "resource_policy_allow_cidr_block_list" {
  description = "List of source IP or CIDR blocks - to be used by resource policy -- Allow rule"
  type        = list(any)
  default     = []
}