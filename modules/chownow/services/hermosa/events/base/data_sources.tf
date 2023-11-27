data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "datadog_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret" "configuration" {
  name = "${local.env}/${var.service}/configuration"
}

data "aws_iam_policy_document" "queue_policy_doc" {
  statement {
    actions   = ["sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:GetQueueUrl", "sqs:ReceiveMessage", "sqs:SendMessage"]
    resources = [module.hermosa_sqs.sqs_queue_arn]
  }
}

data "aws_iam_policy_document" "low_priority_queue_policy_doc" {
  statement {
    actions   = ["sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:GetQueueUrl", "sqs:ReceiveMessage", "sqs:SendMessage"]
    resources = [module.hermosa_low_priority_sqs.sqs_queue_arn]
  }
}

data "aws_iam_policy_document" "allow_secrets_doc" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      data.aws_secretsmanager_secret.datadog_ops_api_key.arn,
      data.aws_secretsmanager_secret.configuration.arn
    ]
  }
}

data "aws_iam_policy_document" "custom_standard_queue_policy" {
  count = local.has_custom_standard_queue_policy ? 1 : 0

  statement {
    actions = ["sqs:SendMessage", "sqs:SendMessageBatch"]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    resources = [module.hermosa_sqs.sqs_queue_arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = local.standard_queue_allowed_topic_subscriptions
    }
  }
}
