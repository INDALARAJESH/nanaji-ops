resource "aws_iam_policy" "queue_policy" {
  name   = var.sqs_queue_name
  policy = data.aws_iam_policy_document.queue_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = var.lambda_iam_role_id
  policy_arn = aws_iam_policy.queue_policy.arn
}
