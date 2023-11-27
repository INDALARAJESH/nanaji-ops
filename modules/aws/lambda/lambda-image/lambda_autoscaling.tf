resource "aws_lambda_provisioned_concurrency_config" "newest" {
  count                             = !var.lambda_autoscaling && var.lambda_publish && var.lambda_provisioned_concurrency > 0 ? 1 : 0
  function_name                     = aws_lambda_alias.newest[0].function_name
  qualifier                         = aws_lambda_alias.newest[0].name
  provisioned_concurrent_executions = var.lambda_provisioned_concurrency
}

resource "aws_lambda_provisioned_concurrency_config" "newest_with_autoscaling" {
  count                             = var.lambda_autoscaling && var.lambda_publish && var.lambda_provisioned_concurrency > 0 ? 1 : 0
  function_name                     = aws_lambda_alias.newest[0].function_name
  qualifier                         = aws_lambda_alias.newest[0].name
  provisioned_concurrent_executions = var.lambda_provisioned_concurrency

  lifecycle {
    ignore_changes = [
      provisioned_concurrent_executions # handled by autoscaling
    ]
  }
}

resource "aws_appautoscaling_target" "lambda_target_for_newest" {
  count              = var.lambda_publish && var.lambda_autoscaling ? 1 : 0
  min_capacity       = var.lambda_autoscaling_min_capacity
  max_capacity       = var.lambda_autoscaling_max_capacity
  resource_id        = "function:${aws_lambda_alias.newest[0].function_name}:${aws_lambda_alias.newest[0].name}"
  scalable_dimension = "lambda:function:ProvisionedConcurrency"
  service_namespace  = "lambda"
}

resource "aws_appautoscaling_policy" "lambda_provisioned_concurrency_policy_for_newest" {
  count              = var.lambda_publish && var.lambda_autoscaling ? 1 : 0
  name               = "LambdaProvisionedConcurrency:${aws_lambda_alias.newest[0].function_name}"
  resource_id        = aws_appautoscaling_target.lambda_target_for_newest[0].resource_id
  scalable_dimension = aws_appautoscaling_target.lambda_target_for_newest[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.lambda_target_for_newest[0].service_namespace
  policy_type        = "TargetTrackingScaling"

  #  https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html
  #  ProvisionedConcurrencyUtilization – For a version or alias,
  #  the value of ProvisionedConcurrentExecutions divided by the total amount of provisioned concurrency allocated.
  #  For example, .5 indicates that 50 percent of allocated provisioned concurrency is in use.
  target_tracking_scaling_policy_configuration {
    disable_scale_in = false
    target_value     = 0.9
    predefined_metric_specification {
      predefined_metric_type = "LambdaProvisionedConcurrencyUtilization"
    }
  }
}
