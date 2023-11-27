
variable "alarm_cpuutilization_cycles" {
  description = "How many evaluation periods breaking thresholds before alarming"
  default     = 10
}

variable "alarm_cpuutilization_threshold" {
  description = "Percentage CPU Utilization above which is alarm condition"
  default     = 90
}

variable "alarm_actions" {
  description = "List of ARNs to notifiy on alarm"
  default     = ["arn:aws:sns:us-east-1:234359455876:pagerduty"]
}
