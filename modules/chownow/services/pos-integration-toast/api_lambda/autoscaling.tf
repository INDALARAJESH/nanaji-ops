resource "aws_lambda_provisioned_concurrency_config" "api_autoscaling_config" {
  count                             = var.enable_lambda_autoscaling ? 1 : 0
  function_name                     = aws_lambda_alias.api_alias.function_name
  qualifier                         = aws_lambda_alias.api_alias.name
  provisioned_concurrent_executions = var.lambda_provisioned_concurrency

  lifecycle {
    ignore_changes = [
      provisioned_concurrent_executions # handled by autoscaling
    ]
  }
}

resource "aws_appautoscaling_target" "api_autoscaling_target" {
  count              = var.enable_lambda_autoscaling ? 1 : 0
  min_capacity       = var.lambda_autoscaling_min_capacity
  max_capacity       = var.lambda_autoscaling_max_capacity
  resource_id        = "function:${aws_lambda_alias.api_alias.function_name}:${aws_lambda_alias.api_alias.name}"
  scalable_dimension = "lambda:function:ProvisionedConcurrency"
  service_namespace  = "lambda"
}

resource "aws_appautoscaling_policy" "api_autoscaling_policy" {
  count              = var.enable_lambda_autoscaling ? 1 : 0
  name               = "LambdaProvisionedConcurrency:${aws_lambda_alias.api_alias.function_name}"
  resource_id        = aws_appautoscaling_target.api_autoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.api_autoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.api_autoscaling_target[0].service_namespace
  policy_type        = "TargetTrackingScaling"

  #  https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html
  #  ProvisionedConcurrencyUtilization – For a version or alias,
  #  the value of ProvisionedConcurrentExecutions divided by the total amount of provisioned concurrency allocated.
  #  For example, .5 indicates that 50 percent of allocated provisioned concurrency is in use.
  target_tracking_scaling_policy_configuration {
    disable_scale_in = false
    target_value     = var.lambda_provisioned_concurrency_autoscaling_target
    predefined_metric_specification {
      predefined_metric_type = "LambdaProvisionedConcurrencyUtilization"
    }
  }
}
