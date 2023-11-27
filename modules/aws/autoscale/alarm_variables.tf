variable "alarm_description" {
  description = "triggers ecs autoscaling"
  default     = "This metric monitors ecs container metrics"
}

variable "alarm_dimensions" {
  description = "dimensions for the alarm_out associated metric"
  default     = {}
}

variable "alarm_namespace" {
  description = "the namespace for the alarm's associated metric"
  default     = "AWS/ECS"
}

variable "alarm_metric_thresholds" {
  description = "the thresholds for the alarm's associated metric"

  default = {
    CPUUtilization    = 50
    MemoryUtilization = 50
  }
}

variable "alarm_threshold" {
  description = "the value against which the specified statistic is compared"
  default     = "50"
}

## Alarm Scaling Out variables
## Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html

variable "alarm_out_evaluation_periods" {
  description = "the number of alarm_out periods over which data is compared to the specified threshold"
  default     = 2
}

variable "alarm_out_period" {
  description = "the period in seconds over which the specified statistic is applied for alarm_out"
  default     = 60
}

variable "alarm_out_statistic" {
  description = "the statistic to apply to alarm_out associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

## Alarm Scaling In variables

variable "alarm_in_evaluation_periods" {
  description = "the number of periods over which data is compared to the specified threshold"
  default     = 10
}

variable "alarm_in_period" {
  description = "the period in seconds over which the specified statistic is applied for alarm_in"
  default     = 60
}

variable "alarm_in_statistic" {
  description = "the statistic to apply to alarm_in associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}
