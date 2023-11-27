variable "sqs_queue_name" {
  description = "name of sqs queue"
}

variable "visibility_timeout_seconds" {
  description = "visibility timeout in seconds - AWS recommends this to be at least 6x the lambda function timeout value"
  default     = 60
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

variable "max_receive_count" {
  description = "number of times a message is delivered to queue before sending to dlq"
  default     = 2
}
