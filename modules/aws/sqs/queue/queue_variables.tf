variable "sqs_queue_name" {
  description = "name of sqs queue"
}

variable "visibility_timeout_seconds" {
  description = "visibility timeout seconds"
  default     = 600
}

variable "message_retention_seconds" {
  description = "message retention seconds"
  default     = 345600
}

variable "max_message_size" {
  description = "max message size"
  default     = 262144
}

variable "delay_seconds" {
  description = "delay seconds"
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "receive wait time seconds"
  default     = 20
}

variable "fifo_queue" {
  description = "true to create a fifo queue"
  default     = false
}

variable "redrive_policy" {
  description = "redrive policy for queue"
  default     = ""
}

variable "custom_queue_policy_json" {
  description = "Custom queue policy JSON to be applied to the queue. If not passed, the AWS standard queue policy is applied"
  default     = null
}
