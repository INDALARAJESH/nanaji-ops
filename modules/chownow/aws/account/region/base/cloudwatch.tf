data "aws_iam_policy_document" "main" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "main" {
  count = var.enable_cw_log_resource_policy

  policy_document = data.aws_iam_policy_document.main.json
  policy_name     = "cloudwatch-logs-${local.env}"
}
