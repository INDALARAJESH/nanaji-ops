# EC2
data "aws_iam_policy_document" "tenable_restart_ec2" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:Describe*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "tenable_restart_ec2" {
  name        = "tenable-lambda-extra-ec2"
  description = "Allows Tenable Lambdas to use ec2"
  policy      = data.aws_iam_policy_document.tenable_restart_ec2.json
}

resource "aws_iam_role_policy_attachment" "tenable_on_ec2" {
  role       = module.tenable_on_function.lambda_iam_role_name
  policy_arn = aws_iam_policy.tenable_restart_ec2.arn
}

resource "aws_iam_role_policy_attachment" "tenable_off_ec2" {
  role       = module.tenable_off_function.lambda_iam_role_name
  policy_arn = aws_iam_policy.tenable_restart_ec2.arn
}

# Secrets - Allow Lambda to access slack token
data "aws_iam_policy_document" "allow_secrets" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:${var.env}/chownow_common/*"]
  }
}

resource "aws_iam_policy" "allow_secrets" {
  name        = "tenable-lambda-read-secrets"
  description = "Allows Tenable Lambdas to read secretsmanager secret(s)"
  policy      = data.aws_iam_policy_document.allow_secrets.json
}

resource "aws_iam_role_policy_attachment" "allow_secrets_on" {
  role       = module.tenable_on_function.lambda_iam_role_name
  policy_arn = aws_iam_policy.allow_secrets.arn
}

resource "aws_iam_role_policy_attachment" "allow_secrets_off" {
  role       = module.tenable_off_function.lambda_iam_role_name
  policy_arn = aws_iam_policy.allow_secrets.arn
}
