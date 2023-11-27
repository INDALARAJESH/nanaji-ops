variable "patch_manager_scan_schedule" {
  description = "default schedule for scanning"
  default     = "cron(5 14 ? * * *)"
}

variable "patch_manager_patch_schedule" {
  description = "default schedule for patching"
  default     = "cron(0 12 ? * * *)"
}
