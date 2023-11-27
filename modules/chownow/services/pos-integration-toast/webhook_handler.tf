# Toast webhook lambda
resource "aws_lambda_function" "webhook" {
  description   = "webhook lambda"
  function_name = "${local.service}-webhook-${local.env}"
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.webhook.arn
  package_type  = "Image"
  image_uri     = "${local.image_repository_url}:${var.lambda_image_tag}"
  timeout       = var.lambda_timeout
  publish       = true

  environment {
    variables = merge(
      {
        PARTNER_EVENT_QUEUE_NAME                          = aws_ssm_parameter.partner_event_queue_name.value
        MENUS_EVENT_QUEUE_NAME                            = aws_ssm_parameter.menus_event_queue_name.value
        SENTRY_DSN                                        = aws_ssm_parameter.sentry_dsn.value
        STOCK_EVENT_QUEUE_NAME                            = aws_ssm_parameter.stock_event_queue_name.value
        DD_LAMBDA_HANDLER                                 = var.webhook_processor_lambda_command
        TOAST_MENUS_EVENT_WEBHOOK_SECRET_PARAMETER_NAME   = aws_ssm_parameter.toast_menus_event_webhook_secret.name
        TOAST_PARTNER_EVENT_WEBHOOK_SECRET_PARAMETER_NAME = aws_ssm_parameter.toast_partner_event_webhook_secret.name
        TOAST_STOCK_EVENT_WEBHOOK_SECRET_PARAMETER_NAME   = aws_ssm_parameter.toast_stock_event_webhook_secret.name
        LAUNCHDARKLY_SDK_KEY                              = data.aws_secretsmanager_secret_version.launch_darkly_sdk_key.arn
      },
      local.datadog_env_vars
    )
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_iam_role" "webhook" {
  name               = "${local.service}-lambda-webhook"
  description        = "webhook lambda role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  lifecycle {
    create_before_destroy = false
  }
}

# CloudWatch Log Group for Lambda fn
resource "aws_cloudwatch_log_group" "webhook" {
  name              = "/aws/lambda/${aws_lambda_function.webhook.function_name}"
  retention_in_days = var.cloudwatch_logs_retention
}

#
# Base policy attachment
#
resource "aws_iam_role_policy_attachment" "lambda_base" {
  role       = aws_iam_role.webhook.name
  policy_arn = aws_iam_policy.lambda_base.arn
}

#
# SQS policy attachment to allow webhook lambda to put messages on handler queues
#
resource "aws_iam_policy" "webhook_queue_policy" {
  name   = "${local.service}-lambda-webhook-sqs-${var.env}"
  policy = data.aws_iam_policy_document.webhook_queue_policy_doc.json
}

# Note: you will need to include the ARN for all queues that the webhook lambda places messages on
data "aws_iam_policy_document" "webhook_queue_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage", "sqs:GetQueueUrl", "sqs:GetQueueAttributes"]
    resources = [module.partner.queue_arn, module.menu.queue_arn, module.stock.queue_arn]
  }
}

resource "aws_iam_role_policy_attachment" "webhook_sqs" {
  role       = aws_iam_role.webhook.name
  policy_arn = aws_iam_policy.webhook_queue_policy.arn
}

resource "aws_iam_role_policy_attachment" "webhook_policy_attachment_ssm_param" {
  role       = aws_iam_role.webhook.name
  policy_arn = aws_iam_policy.ssm_param.arn
}

#
# AWS Lambda Alias to allow webhook lambda to configure enable provisioned concurrency & autoscaling.
#
resource "aws_lambda_alias" "webhook_alias" {
  name             = "newest"
  description      = aws_lambda_function.webhook.description
  function_name    = aws_lambda_function.webhook.function_name
  function_version = aws_lambda_function.webhook.version
}

#
# AWS Lambda Provisioned Concurrency Configuration for webhook lambda
#
resource "aws_lambda_provisioned_concurrency_config" "webhook_autoscaling_config" {
  count                             = var.enable_lambda_autoscaling ? 1 : 0
  function_name                     = aws_lambda_alias.webhook_alias.function_name
  qualifier                         = aws_lambda_alias.webhook_alias.name
  provisioned_concurrent_executions = var.lambda_provisioned_concurrency

  lifecycle {
    ignore_changes = [
      provisioned_concurrent_executions # handled by autoscaling
    ]
  }
}

#
# AWS Lambda App Autoscaling Target configuration for webhook lambda
#
resource "aws_appautoscaling_target" "webhook_autoscaling_target" {
  count              = var.enable_lambda_autoscaling ? 1 : 0
  min_capacity       = var.lambda_autoscaling_min_capacity
  max_capacity       = var.lambda_autoscaling_max_capacity
  resource_id        = "function:${aws_lambda_alias.webhook_alias.function_name}:${aws_lambda_alias.webhook_alias.name}"
  scalable_dimension = "lambda:function:ProvisionedConcurrency"
  service_namespace  = "lambda"
}

#
# AWS Lambda App Autoscaling Policy for webhook lambda
#
resource "aws_appautoscaling_policy" "webhook_autoscaling_policy" {
  count              = var.enable_lambda_autoscaling ? 1 : 0
  name               = "LambdaProvisionedConcurrency:${aws_lambda_alias.webhook_alias.function_name}"
  resource_id        = aws_appautoscaling_target.webhook_autoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.webhook_autoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.webhook_autoscaling_target[0].service_namespace
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
