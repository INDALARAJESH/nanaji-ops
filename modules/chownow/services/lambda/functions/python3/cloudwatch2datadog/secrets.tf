data "aws_secretsmanager_secret" "dd_api_key" {
  name = local.dd_api_key_secret_path
}

data "aws_iam_policy_document" "allow_secrets" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [data.aws_secretsmanager_secret.dd_api_key.arn]
  }
}

resource "aws_iam_policy" "allow_secrets" {
  name        = "${module.function.lambda_function_name}-read-secrets"
  description = "Allows ${module.function.lambda_function_name} to read secretsmanager secret(s)"
  policy      = data.aws_iam_policy_document.allow_secrets.json
}

resource "aws_iam_role_policy_attachment" "allow_secrets" {
  role       = module.function.lambda_iam_role_name
  policy_arn = aws_iam_policy.allow_secrets.arn
}
