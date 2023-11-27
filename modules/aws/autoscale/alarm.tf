resource "aws_cloudwatch_metric_alarm" "step_scalin_out" {
  count = var.scaling_policy_type == "step" ? length(var.alarm_metric_thresholds) : 0

  alarm_name          = "${local.autoscale_name}-alarm-out-${count.index}"
  alarm_actions       = [aws_appautoscaling_policy.step_scaling_out[count.index].arn]
  alarm_description   = "Out: ${var.alarm_description}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_out_evaluation_periods
  metric_name         = element(keys(var.alarm_metric_thresholds), count.index)
  namespace           = var.alarm_namespace
  period              = var.alarm_out_period
  statistic           = var.alarm_out_statistic
  threshold           = element(values(var.alarm_metric_thresholds), count.index)
  dimensions          = var.alarm_dimensions

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.autoscale_name}-alarm-out"
    "ScaleDirection" = "Out" }
  )
}

resource "aws_cloudwatch_metric_alarm" "step_scalin_in" {
  count = var.scaling_policy_type == "step" ? length(var.alarm_metric_thresholds) : 0

  alarm_name          = "${local.autoscale_name}-alarm-in-${count.index}"
  alarm_actions       = [aws_appautoscaling_policy.step_scaling_in[count.index].arn]
  alarm_description   = "In: ${var.alarm_description}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_in_evaluation_periods
  metric_name         = element(keys(var.alarm_metric_thresholds), count.index)
  namespace           = var.alarm_namespace
  period              = var.alarm_in_period
  statistic           = var.alarm_in_statistic
  threshold           = element(values(var.alarm_metric_thresholds), count.index)
  dimensions          = var.alarm_dimensions

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.autoscale_name}-alarm-in"
    "ScaleDirection" = "In" }
  )
}
