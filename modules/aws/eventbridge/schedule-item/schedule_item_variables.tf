variable "schedule_item_name" {
  description = "schedule item name, eg: daily_important_report"
}

variable "schedule_item_expression" {
  description = "schedule expression (cron or rate)"
}

variable "schedule_item_json" {
  description = "schedule item json target input"
}

variable "schedule_item_enabled_disabled" {
  description = "schedule item is ENABLED or DISABLED"
  default     = "ENABLED"
}

variable "schedule_target_arn" {
  description = "arn used to send event to target"
  default     = "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"
}
