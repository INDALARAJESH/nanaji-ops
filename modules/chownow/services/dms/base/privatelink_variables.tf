variable "enable_privatelink" {
  description = "enables/disables privatelink functionality"
  default     = 0
}

variable "service_provider_aws_account_ids" {
  description = "list of AWS Account IDs to allow access to privatelink service provider"
  default     = []
}
