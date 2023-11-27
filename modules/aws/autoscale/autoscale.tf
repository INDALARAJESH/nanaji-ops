resource "aws_appautoscaling_target" "target" {
  count              = var.create_appautoscaling_target ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = var.target_resource_id
  scalable_dimension = var.target_scalable_dimension
  service_namespace  = var.target_service_namespace
}

resource "aws_appautoscaling_policy" "step_scaling_out" {
  count = var.scaling_policy_type == "step" ? 1 : 0

  name               = "${local.autoscale_name}-out"
  policy_type        = "StepScaling"
  resource_id        = var.target_resource_id
  scalable_dimension = var.target_scalable_dimension
  service_namespace  = var.target_service_namespace

  step_scaling_policy_configuration {
    adjustment_type          = var.policy_adjustment_type
    cooldown                 = var.policy_scale_out_cooldown
    metric_aggregation_type  = var.policy_metric_aggregation_type
    min_adjustment_magnitude = var.policy_min_adjustment_magnitude

    dynamic "step_adjustment" {
      for_each = var.policy_step_adjustments_out
      content {
        metric_interval_lower_bound = step_adjustment.value["metric_interval_lower_bound"]
        metric_interval_upper_bound = step_adjustment.value["metric_interval_upper_bound"]
        scaling_adjustment          = step_adjustment.value["scaling_adjustment"]
      }
    }
  }
}

resource "aws_appautoscaling_policy" "step_scaling_in" {
  count = var.scaling_policy_type == "step" ? 1 : 0

  name               = "${local.autoscale_name}-in"
  policy_type        = "StepScaling"
  resource_id        = var.target_resource_id
  scalable_dimension = var.target_scalable_dimension
  service_namespace  = var.target_service_namespace

  step_scaling_policy_configuration {
    adjustment_type          = var.policy_adjustment_type
    cooldown                 = var.policy_scale_in_cooldown
    metric_aggregation_type  = var.policy_metric_aggregation_type
    min_adjustment_magnitude = var.policy_min_adjustment_magnitude

    dynamic "step_adjustment" {
      for_each = var.policy_step_adjustments_in
      content {
        metric_interval_lower_bound = step_adjustment.value["metric_interval_lower_bound"]
        metric_interval_upper_bound = step_adjustment.value["metric_interval_upper_bound"]
        scaling_adjustment          = step_adjustment.value["scaling_adjustment"]
      }
    }
  }
}

resource "aws_appautoscaling_policy" "target_tracking_scaling" {
  count = var.scaling_policy_type == "target-tracking" ? length(var.policy_target_conditions) : 0

  name               = "${local.autoscale_name}${count.index}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = var.target_resource_id
  scalable_dimension = var.target_scalable_dimension
  service_namespace  = var.target_service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = lookup(var.policy_target_conditions[count.index], "value")
    disable_scale_in   = var.policy_disable_scale_in
    scale_in_cooldown  = var.policy_scale_in_cooldown
    scale_out_cooldown = var.policy_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = lookup(var.policy_target_conditions[count.index], "metric")
      resource_label         = lookup(var.policy_target_conditions[count.index], "metric") == "ALBRequestCountPerTarget" ? lookup(var.policy_target_conditions[count.index], "resource_label") : ""
    }
  }
}

resource "aws_appautoscaling_scheduled_action" "scheduled" {
  count              = var.scaling_policy_type == "scheduled" ? length(var.scheduled_scalings) : 0
  name               = "${local.autoscale_name}${count.index}"
  resource_id        = var.target_resource_id
  scalable_dimension = var.target_scalable_dimension
  service_namespace  = var.target_service_namespace
  schedule           = var.scheduled_scalings[count.index].schedule

  scalable_target_action {
    min_capacity = var.scheduled_scalings[count.index].min_capacity
    max_capacity = var.scheduled_scalings[count.index].max_capacity
  }
}
