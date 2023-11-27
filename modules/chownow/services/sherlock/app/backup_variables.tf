variable "backup_schedule" {
  description = "cron schedule for backup"
  default     = "cron(0 12 * * ? *)"
}

variable "lifecycle_days" {
  description = "how long do back up last"
  default     = "30"
}
