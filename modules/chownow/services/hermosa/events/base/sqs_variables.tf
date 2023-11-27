variable "sqs_queue_name" {
  description = "sqs queue name"
  default     = "hermosa-events"
}

variable "fifo_queue_enabled" {
  description = "true to create a fifo queue"
  default     = false
}

variable "visibility_timeout_seconds" {
  description = "visibility timeout for the queue"
  default     = 360
}

variable "dlq_visibility_timeout_seconds" {
  description = "visibility timeout for dlq"
  default     = 30
}

variable "receive_wait_time_seconds" {
  default = 0 # short polling
}

variable "message_retention_seconds" {
  description = "message retention length in seconds"
  default     = 1209600 # 14 days
}

variable "max_receive_count" {
  description = "max receive count"
  default     = 3
}

variable "sqs_low_priority_queue_name" {
  description = "queue name for events consumer low priority queue"
  default     = "hermosa-events-low-priority"
}

variable "low_priority_visibility_timeout_seconds" {
  description = "visibility timeout for the queue"
  default     = 900
}

variable "low_priority_dlq_visibility_timeout_seconds" {
  description = "visibility timeout for dlq"
  default     = 30
}
