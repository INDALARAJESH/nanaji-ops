variable "log_publishing_index_enabled" {
  type        = string
  default     = "true"
  description = "Specifies whether log publishing option for INDEX_SLOW_LOGS is enabled or not"
}

variable "log_publishing_search_enabled" {
  type        = string
  default     = "true"
  description = "Specifies whether log publishing option for SEARCH_SLOW_LOGS is enabled or not"
}

variable "log_publishing_application_enabled" {
  type        = string
  default     = "true"
  description = "Specifies whether log publishing option for ES_APPLICATION_LOGS is enabled or not"
}
