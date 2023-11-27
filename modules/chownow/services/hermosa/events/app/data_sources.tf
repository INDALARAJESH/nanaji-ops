data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_secretsmanager_secret" "configuration" {
  name = "${local.env}/${var.service}/configuration"
}

data "aws_security_group" "internal_allow" {
  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }
}

data "aws_secretsmanager_secret" "datadog_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_iam_policy" "allow_sqs_queue" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/sqs-${var.service}-${local.env}"
}

data "aws_iam_policy" "allow_low_priority_sqs_queue" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/sqs-${var.low_priority_sqs_queue_name}-${local.env}"
}

data "aws_iam_policy" "allow_lambda_secret_lookup" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/secrets-${var.service}-${local.env}"
}
