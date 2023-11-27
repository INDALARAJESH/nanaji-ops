resource "aws_cloudwatch_metric_alarm" "es_cpuutilization" {
  alarm_name          = "es-cpuutilization-${local.domain_name}"
  alarm_description   = "Elasticsearch CPU Utilization"
  namespace           = "AWS/ES"
  metric_name         = "CPUUtilization"
  period              = "60"
  evaluation_periods  = var.alarm_cpuutilization_cycles
  threshold           = var.alarm_cpuutilization_threshold
  comparison_operator = "GreaterThanThreshold"
  statistic           = "Average"

  alarm_actions = var.alarm_actions

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "es-cpuutilization-${local.domain_name}" }
  )
}
