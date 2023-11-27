data "aws_iam_policy_document" "allow_sns_email" {
  statement {
    effect = "Allow"
    actions = ["sns:Get*",
      "sns:List*",
      "ses:SendEmail",
    "ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow_sns_email" {
  name        = "${module.function.lambda_function_name}-sns-emails"
  description = "Allows ${module.function.lambda_function_name} to read sns and send emails"
  policy      = data.aws_iam_policy_document.allow_sns_email.json
}

resource "aws_iam_role_policy_attachment" "allow_sns_email" {
  role       = module.function.lambda_iam_role_id
  policy_arn = aws_iam_policy.allow_sns_email.arn
}
