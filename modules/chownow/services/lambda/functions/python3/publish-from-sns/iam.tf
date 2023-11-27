data "aws_iam_policy_document" "sns_to_slack_allow_secrets" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [data.aws_secretsmanager_secret.slack_webhook.arn]
  }
}

resource "aws_iam_policy" "sns_to_slack_allow_secrets" {
  name        = "${module.sns_to_slack_lambda.lambda_function_name}-read-secrets"
  description = "Allows ${module.sns_to_slack_lambda.lambda_function_name} to read secretsmanager secret(s)"
  policy      = data.aws_iam_policy_document.sns_to_slack_allow_secrets.json
}

resource "aws_iam_role_policy_attachment" "allow_secrets" {
  role       = module.sns_to_slack_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.sns_to_slack_allow_secrets.arn
}
