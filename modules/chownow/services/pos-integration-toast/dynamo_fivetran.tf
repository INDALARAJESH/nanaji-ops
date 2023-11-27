# Used to allow DnA to read from our dynamo streams via their fivetran integration

locals {
  fivetran_aws_account_id = "834469178297"
}

resource "aws_iam_role" "fivetran_dynamo" {
  count = (var.enable_dynamo_stream && var.enable_fivetran_dynamo_integration) ? 1 : 0

  name               = "${local.service}-fivetran-dynamo-stream"
  description        = "Role to allow fivetran to access dynamo stream for ${local.service}"
  assume_role_policy = data.aws_iam_policy_document.fivetran_assume.json
}

resource "aws_iam_role_policy_attachment" "fivetran" {
  count = (var.enable_dynamo_stream && var.enable_fivetran_dynamo_integration) ? 1 : 0

  role       = aws_iam_role.fivetran_dynamo[count.index].name
  policy_arn = aws_iam_policy.dynamodb_stream_access[count.index].arn
}

resource "aws_iam_policy" "dynamodb_stream_access" {
  count = (var.enable_dynamo_stream && var.enable_fivetran_dynamo_integration) ? 1 : 0

  name        = "${local.service}-dynamodb-stream-access"
  description = "DynamoDB policy enabling data to ingest from stream for ${local.service}"
  policy      = data.aws_iam_policy_document.fivetran_dynamodb_stream_policy.json
}

data "aws_iam_policy_document" "fivetran_dynamodb_stream_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:ListTables"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:Scan"
    ]
    resources = [
      aws_dynamodb_table.toast.arn,
      aws_dynamodb_table.toast_orders.arn,
      "${aws_dynamodb_table.toast.arn}/*",
      "${aws_dynamodb_table.toast_orders.arn}/*",
    ]
  }
}

# This allows fivetran to assume the role defined above by also passing
# the external_id configured by the DnA team
data "aws_iam_policy_document" "fivetran_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.fivetran_aws_account_id}:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "judgement_glutton"
      ]
    }
  }
}

