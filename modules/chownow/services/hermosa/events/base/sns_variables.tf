variable "sns_memberships_topic_arn" {
  description = "The ARN of the SNS topic for membership events"
  default     = null
}

variable "sns_order_delivery_topic_arn" {
  description = "The ARN of the SNS topic for order delivery events"
  default     = null
}

variable "membership_updated_message_type_filter" {
  description = "The value of the message attribute `type` that should be filtered on"
  default     = "com.chownow.membership.updated"
}
