resource "aws_iam_policy" "dynamodb_policy" {
  name   = "dynamodb-policy-${var.service}-${local.env}"
  policy = data.aws_iam_policy_document.dynamodb_policy_doc.json
}
