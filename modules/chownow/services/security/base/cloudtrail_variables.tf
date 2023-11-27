variable "monitored_buckets_list" {
  description = "list of monitored s3"
  type        = list(string)
  default     = []
}

variable "include_global_service_events" {
  description = "include global service events"
  default     = false
}

variable "is_multi_region_trail" {
  description = "boolean for enabling multi-region"
  default     = false
}

variable "event_selector_rwt" {
  description = "event selector read/write type"
  default     = "All"
}

variable "event_selector_ime" {
  description = "event selector include management events"
  default     = true
}

variable "data_resource_type" {
  description = "data resource type"
  default     = "AWS::S3::Object"
}

variable "enable_cloudtrail_dd" {
  description = "enables/disables cloudtrail forwarding to datadog"
  default     = 0
}
