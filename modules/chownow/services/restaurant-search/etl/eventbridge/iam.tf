data "aws_iam_policy_document" "cross_account_policy" {
  count = length(var.cross_account_identifiers)
  statement {
    principals {
      identifiers = var.cross_account_identifiers
      type        = "AWS"
    }

    effect = "Allow"

    actions = [
      "events:ListRules",
      "events:DisableRule",
      "events:EnableRule"
    ]

    resources = [
      "arn:aws:events:us-east-1:${data.aws_caller_identity.current.account_id}:rule/*"
    ]
  }
}

data "aws_iam_policy_document" "cross_account" {
  count = length(var.cross_account_identifiers)
  statement {
    sid    = "CrossAccountAccess"
    effect = "Allow"
    actions = [
      "events:ListRules"
    ]
    resources = [
      "arn:aws:events:us-east-1:${data.aws_caller_identity.current.account_id}:event-bus/default",
      "arn:aws:events:us-east-1:${data.aws_caller_identity.current.account_id}:rule/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.cross_account_identifiers
    }
  }
  statement {
    sid    = "CrossAccountAccessDisableRule"
    effect = "Allow"
    actions = [
      "events:DisableRule",
      "events:EnableRule"
    ]
    resources = [
      "arn:aws:events:us-east-1:${data.aws_caller_identity.current.account_id}:rule/${aws_cloudwatch_event_rule.restaurant-search-backfill.name}"
    ]

    principals {
      type        = "AWS"
      identifiers = var.cross_account_identifiers
    }
  }
}
