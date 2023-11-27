### Lambda Policy
resource "aws_iam_policy" "lambda" {
  name        = "${local.app_name}_lambda"
  path        = "/lambda_policies/${local.app_name}/"
  description = "Policy to give ${local.app_name} specific functionality"
  policy      = data.template_file.lambda_policy.rendered
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = module.function.lambda_iam_role_name
  policy_arn = aws_iam_policy.lambda.arn
}
