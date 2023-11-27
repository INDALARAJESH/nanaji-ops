variable "scaling_policy_type" {
  description = "type of scaling policy (valid values are step, target-tracking, scheduled)"
  default     = "target-tracking"
}

## aws_appautoscaling_target variables
## Ref: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html

variable "max_capacity" {
  description = "maximum number of targets to scale"
  default     = 5
}

variable "min_capacity" {
  description = "minimum number of targets to scale"
  default     = 1
}

# Swap to locals and accept cluster/service names
variable "target_resource_id" {
  description = "resource type and unique identifier string for the resource associated with the scaling policy"
}

variable "target_scalable_dimension" {
  description = "the scalable dimension associated with the scalable target"
  default     = "ecs:service:DesiredCount"
}

variable "target_service_namespace" {
  description = "the AWS service namespace of the scalable target"
  default     = "ecs"
}

## aws_appautoscaling_policy variables
## Ref: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScalingPolicy.html

# Step-Scale variables
variable "policy_adjustment_type" {
  description = "specifies whether the adjustment is an absolute number or a percentage of the current capacity"
  default     = "PercentChangeInCapacity"
}

variable "policy_min_adjustment_magnitude" {
  description = "the minimum number to adjust your scalable dimension as a result of a scaling activity"
  default     = 1
}

variable "policy_scale_out_cooldown" {
  description = "the amount of time (in seconds) after a scaling activity completes and before the next scaling activity can start"
  default     = 120
}

variable "policy_scale_in_cooldown" {
  description = "the amount of time (in seconds) after a scaling activity completes and before the next scaling activity can start"
  default     = 600
}

variable "policy_metric_aggregation_type" {
  description = "the aggregation type for the policy's metrics"
  default     = "Average"
}

variable "policy_step_adjustments_out" {
  description = "list of policy step adjustments for scaling out"

  default = [
    {
      # Between threshold and threshold+10%, scale by 0%
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 10
      scaling_adjustment          = 0
    },
    {
      # Between threshold+10% and threshold+25%, scale by +25%
      metric_interval_lower_bound = 10
      metric_interval_upper_bound = 25
      scaling_adjustment          = 25
    },
    {
      # Between threshold+25% and infiniti, scale by +50%
      metric_interval_lower_bound = 25
      scaling_adjustment          = 50
    },
  ]
}

variable "policy_step_adjustments_in" {
  description = "list of policy step adjustments for scaling in"

  default = [
    {
      # Between threshold and threshold-10%, scale by 0%
      metric_interval_lower_bound = -10
      metric_interval_upper_bound = 0
      scaling_adjustment          = 0
    },
    {
      # Between threshold-10% and threshold-25%, scale by -10%
      metric_interval_lower_bound = -25
      metric_interval_upper_bound = -10
      scaling_adjustment          = -10
    },
    {
      # Between threshold-25% and -infiniti, scale by -25%
      metric_interval_upper_bound = -25
      scaling_adjustment          = -25
    },
  ]
}

## TargetTracking-Scale variables
## Ref: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_TargetTrackingScalingPolicyConfiguration.html
## Ref: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PredefinedMetricSpecification.html

## TODO: wrap var.policy_target_conditions in jsondecode() once migrated to >=v0.12
variable "policy_target_conditions" {
  description = "map of target tracking scaling metric and value"

  default = [
    {
      metric = "ECSServiceAverageCPUUtilization"
      value  = 67
    },
    {
      metric = "ECSServiceAverageMemoryUtilization"
      value  = 67
    },
  ]
}

variable "policy_disable_scale_in" {
  description = "boolean toggle to disable scale-in"
  default     = false
}

variable "schedule" {
  description = "schedule for scheduled scaling action"
  default     = ""
}

variable "scheduled_max_capacity" {
  description = "maximum number of targets to scale on schedule"
  default     = 5
}

variable "scheduled_min_capacity" {
  description = "minimum number of targets to scale on schedule"
  default     = 1
}

variable "scheduled_scalings" {
  description = "list of scheduled scalings"
  type        = list(object({ schedule = string, min_capacity = number, max_capacity = number }))
  default     = []
}

variable "create_appautoscaling_target" {
  description = "create appautoscaling target resource in the module if true"
  default     = true
}
