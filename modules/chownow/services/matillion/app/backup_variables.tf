variable "schedule" {
  description = "cron schedule for backup"
  default     = "cron(0 12 * * ? *)"
}

variable "lifecycle_days" {
  description = "amount of days to retain backup"
  default     = "30"
}
