data "aws_iam_policy_document" "scheduler_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "queue_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [data.aws_sqs_queue.target_sqs_queue_name.arn]
  }
}

resource "aws_iam_role" "eventbridge_scheduler_role" {
  name               = local.scheduler_role_name
  description        = "${local.scheduler_role_name} eventbridge role"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_policy" "eventbridge_queue_policy" {
  name   = local.policy_name
  policy = data.aws_iam_policy_document.queue_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "scheduler_role_policy_attachment" {
  role       = aws_iam_role.eventbridge_scheduler_role.name
  policy_arn = aws_iam_policy.eventbridge_queue_policy.arn
}
