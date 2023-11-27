variable "dd_api_key" {
  description = "a value that's required, but not used"
  default     = "this_value_is_not_used"
}

variable "integration_external_id" {
  description = "generate an integration ID on datadog page"
}

variable "dd_capabilities" {
  description = "datadog cloudformation stack capabilities"
  default     = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
}
