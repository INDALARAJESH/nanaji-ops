data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "dynamodb_policy_doc" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:Update*"
    ]
    resources = [
      local.dynamodb_arn
    ]
  }
}
