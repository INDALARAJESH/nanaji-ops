variable "sqs_queue_name" {
  description = "sqs queue name"
  default     = "memberships"
}

variable "visibility_timeout_seconds" {
  default = 900
}
