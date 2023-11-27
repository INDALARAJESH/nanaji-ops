variable "api_id" {
  description = "id of API gateway"
}

variable "lambda_arn" {
  description = "arn of the lambda to call"
}

variable "lambda_invoke_arn" {
  description = "invoke arn of the lambda to call"
}

variable "enable_default_route" {
  description = "enable default route"
  default     = 1
}

variable "path_prefix" {
  description = "HTTP path prefix. ie '/fbe' "
  default     = ""
}

variable "payload_format_version" {
  description = "The format of the payload sent to an integration. Valid values: 1.0, 2.0"
  default     = "2.0"
}

variable "source_arn_permission_path" {
  description = "Permission path, prefixed with api gateway "
  default     = "/*/*/*"
}
