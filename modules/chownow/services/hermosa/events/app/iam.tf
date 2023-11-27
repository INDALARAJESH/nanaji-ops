resource "aws_iam_role_policy_attachment" "allow_lambda_sqs" {
  role       = module.hermosa_lambda.lambda_iam_role_id
  policy_arn = data.aws_iam_policy.allow_sqs_queue.arn
}

resource "aws_iam_role_policy_attachment" "allow_lambda_secret_lookup" {
  role       = module.hermosa_lambda.lambda_iam_role_id
  policy_arn = data.aws_iam_policy.allow_lambda_secret_lookup.arn
}

resource "aws_iam_role_policy_attachment" "allow_low_priority_lambda_sqs" {
  role       = module.hermosa_low_priority_lambda.lambda_iam_role_id
  policy_arn = data.aws_iam_policy.allow_low_priority_sqs_queue.arn
}

resource "aws_iam_role_policy_attachment" "allow_low_priority_lambda_secret_lookup" {
  role       = module.hermosa_low_priority_lambda.lambda_iam_role_id
  policy_arn = data.aws_iam_policy.allow_lambda_secret_lookup.arn
}
