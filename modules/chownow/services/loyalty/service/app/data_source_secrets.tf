data "aws_secretsmanager_secret" "sentry_dsn" {
  name = "${local.env}/${var.app_name}/sentry_dsn"
}

data "aws_secretsmanager_secret" "launchdarkly_sdk_key" {
  name = "${local.env}/${var.app_name}/launchdarkly_sdk_key"
}

data "aws_secretsmanager_secret" "datadog_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret" "sfdc_integration_user" {
  name = "${local.env}/${var.service}/sfdc_integration_user"
}

data "aws_secretsmanager_secret" "sfdc_integration_pass" {
  name = "${local.env}/${var.service}/sfdc_integration_pass"
}

data "aws_secretsmanager_secret" "sfdc_integration_token" {
  name = "${local.env}/${var.service}/sfdc_integration_token"
}

data "aws_secretsmanager_secret" "loyalty_api_key" {
  name = "${local.env}/${var.service}/api_key"
}

data "aws_iam_policy_document" "allow_secrets_doc" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      data.aws_secretsmanager_secret.sfdc_integration_user.arn,
      data.aws_secretsmanager_secret.sfdc_integration_pass.arn,
      data.aws_secretsmanager_secret.sfdc_integration_token.arn,
      data.aws_secretsmanager_secret.sentry_dsn.arn,
      data.aws_secretsmanager_secret.launchdarkly_sdk_key.arn,
      data.aws_secretsmanager_secret.datadog_ops_api_key.arn,
      data.aws_secretsmanager_secret.loyalty_api_key.arn
    ]
  }
}
