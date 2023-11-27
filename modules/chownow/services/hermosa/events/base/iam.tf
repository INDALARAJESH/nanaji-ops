### Lambda Policies

resource "aws_iam_policy" "allow_lambda_secret_lookup" {
  name        = "secrets-${var.service}-${local.env}"
  description = "Allows ${var.service} lambdas to retrieve secrets"
  policy      = data.aws_iam_policy_document.allow_secrets_doc.json
}

resource "aws_iam_policy" "allow_sqs_queue" {
  name        = "sqs-${var.service}-${local.env}"
  description = "Allows ${var.service} lambda to receive sqs queue messages"
  policy      = data.aws_iam_policy_document.queue_policy_doc.json
}

resource "aws_iam_policy" "allow_low_priority_sqs_queue" {
  name        = "sqs-${var.low_priority_service}-${local.env}"
  description = "Allows ${var.service} lambda to receive sqs queue messages"
  policy      = data.aws_iam_policy_document.low_priority_queue_policy_doc.json
}
