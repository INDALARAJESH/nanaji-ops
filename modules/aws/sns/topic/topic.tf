resource "aws_sns_topic" "topic" {
  name       = var.sns_topic_name
  fifo_topic = var.fifo_topic

  lambda_failure_feedback_role_arn    = var.enable_lambda_feedback ? aws_iam_role.sns_feedback.arn : ""
  lambda_success_feedback_role_arn    = var.enable_lambda_feedback ? aws_iam_role.sns_feedback.arn : ""
  lambda_success_feedback_sample_rate = var.enable_lambda_feedback ? var.sns_lambda_success_feedback_sample_rate : ""

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.sns_topic_name }
  )
}
