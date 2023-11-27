data "aws_iam_policy_document" "sns_assume_role" {
  statement {
    sid     = "SNSAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sns_publish_cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "sns_feedback" {
  name               = "${var.sns_topic_name}-sns-feedback-role"
  assume_role_policy = data.aws_iam_policy_document.sns_assume_role.json
}

resource "aws_iam_role_policy" "sns_publish_cloudwatch_logs" {
  name   = "${var.sns_topic_name}-sns-publish-cwlogs-policy"
  role   = aws_iam_role.sns_feedback.id
  policy = data.aws_iam_policy_document.sns_publish_cloudwatch_logs.json
}

# ------------------------------------------------------------------------------
# allow given account to access this topic (cross-account access, eg: prod->ncp)
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "sns_access_policy_doc" {
  statement {
    sid = "CrossAccountSNSAccess"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.sns_cross_account_access_arn]
    }

    actions   = ["sns:Subscribe"]
    resources = [aws_sns_topic.topic.arn]
  }
}

resource "aws_sns_topic_policy" "sns_access_policy" {
  count  = length(var.sns_cross_account_access_arn) > 0 ? 1 : 0
  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns_access_policy_doc.json
}

# ------------------------------------------------------------------------------
