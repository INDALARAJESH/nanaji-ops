### Lambda Policy
### Lambda Execution Role -- https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html

data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "secret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${local.app_name}/*",
      "${data.aws_secretsmanager_secret.dd_api_key.arn}*"
    ]
  }
}

resource "aws_iam_policy" "lambda" {
  name        = "${local.app_name}-lambda"
  path        = "/lambda_policies/${local.app_name}/"
  description = "Policy to give ${local.app_name} specific functionality"
  policy      = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "user_privacy_lambda" {
  role       = module.user_privacy_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.lambda.arn
}
