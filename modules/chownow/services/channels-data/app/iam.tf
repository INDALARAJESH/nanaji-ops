### Lambda Policy
resource "aws_iam_policy" "lambda" {
  name        = "${var.service}_lambda"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.service} Lambda specific functionality"
  policy      = data.template_file.lambda_policy.rendered
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = module.function.lambda_iam_role_name
  policy_arn = aws_iam_policy.lambda.arn
}
