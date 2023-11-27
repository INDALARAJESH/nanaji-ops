variable "custom_monitor_name" {
  description = "unique monitor name"
  default     = ""
}

# monitor types: https://docs.datadoghq.com/api/latest/monitors/#create-a-monitor
variable "monitor_type" {
  description = "datadog provided monitor type"
  default     = "log alert"
}

variable "monitor_message" {
  description = "message to show when monitor is triggered"
}

variable "monitor_escalation_message" {
  description = "optional escalation message"
  default     = ""
}

variable "monitor_query" {
  description = "datadog monitor query"
}

variable "monitor_notify_no_data" {
  description = "enables/disables monitor or alert when data is not received"
  default     = false
}

variable "monitor_no_data_timeframe" {
  description = "enables/disables monitor or alert when data is not received"
  default     = null
}

variable "monitor_renotify_statuses" {
  description = "The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved."
  default     = []
}

variable "monitor_renotify_interval" {
  description = "The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved."
  default     = 60
}

variable "monitor_notify_audit" {
  description = "enables/disables ability for user to be notified when this monitor has changed"
  default     = false
}

variable "monitor_timeout_h" {
  description = "The number of hours of the monitor not reporting data before it will automatically resolve from a triggered state"
  default     = 24
}

variable "monitor_include_tags" {
  description = "enables/disables inclusion of tags to this monitor"
  default     = true
}

variable "monitor_require_full_window" {
  description = "A boolean indicating whether this monitor needs a full window of data before it's evaluated."
  default     = true
}

variable "monitor_new_group_delay" {
  description = "Time (in seconds) to allow a host to boot and applications to fully start before starting the evaluation of monitor results"
  default     = null
}

variable "monitor_new_host_delay" {
  description = ""
  default     = null
}

variable "monitor_critical_threshold" {
  description = "Critical alert threshold for new monitor"
  default     = 0
}

variable "monitor_critical_recovery_threshold" {
  description = "Threshold for when a monitor is considered recovering from a critical state. If not specified, will default to when critical conditions no longer met."
  default     = null
}

variable "monitor_warning_threshold" {
  description = "Warning alert threshold for new monitor"
  default     = null
}

variable "monitor_warning_recovery_threshold" {
  description = "Threshold for when a monitor is considered recovering from a warning state. If not specified, will default to when warning conditions no longer met."
  default     = null
}

variable "monitor_recovery_window" {
  description = "The window to examine for when this monitor should be considered recovering. Required for anomaly monitors."
  default     = "last_15m"
}

variable "monitor_ok_threshold" {
  description = "monitor ok threshold"
  default     = null
}

variable "monitor_trigger_window" {
  description = "The window to examine for when this monitor should trigger an alert. Required for anomaly monitors."
  default     = "last_15m"
}

variable "notification_preset_name" {
  default = "show_all"
}

variable "evaluation_delay" {
  default = "0"
}
