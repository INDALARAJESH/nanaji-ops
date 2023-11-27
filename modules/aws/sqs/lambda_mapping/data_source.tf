data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_sqs_queue" "existing" {
  name = var.sqs_queue_name
}

data "aws_iam_policy_document" "queue_policy_doc" {
  statement {
    actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
    resources = [data.aws_sqs_queue.existing.arn]
  }
}
