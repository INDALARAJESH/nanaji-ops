#
# FireHose
#
data "aws_iam_policy_document" "firehose_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "firehose" {
  name = "${var.service}-${var.env}-firehose-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:List*",
          "kinesis:Describe*",
          "kinesis:Get*"
        ],
        "Resource" : [
          aws_kinesis_stream.launchdarkly.arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "${module.launchdarkly_s3_bucket.bucket_arn}",
          "${module.launchdarkly_s3_bucket.bucket_arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "firehose" {
  name                = "${var.service}-${var.env}-firehose-role"
  assume_role_policy  = data.aws_iam_policy_document.firehose_assume.json
  managed_policy_arns = [aws_iam_policy.firehose.arn]
}

#
# LaunchDarkly
#
data "aws_iam_policy_document" "launchdarkly_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::554582317989:root"]
    }
  }
}

resource "aws_iam_policy" "datastream" {
  name = "${var.service}-${var.env}-datastream-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ],
        "Resource" : [
          aws_kinesis_stream.launchdarkly.arn
        ]
      },
    ]
  })
}

resource "aws_iam_role" "launchdarkly" {
  name                = "${var.service}-${var.env}-launchdarkly-role"
  assume_role_policy  = data.aws_iam_policy_document.launchdarkly_assume.json
  managed_policy_arns = [aws_iam_policy.datastream.arn]
}

#
# FiveTran
#
data "aws_iam_policy_document" "fivetran_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::834469178297:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "judgement_glutton",
      ]
    }
  }
}

resource "aws_iam_policy" "fivetran" {
  name = "${var.service}-${var.env}-launchdarkly-fivetran-policy"

  # per OPS-3499, the fivetran role should have access to every bucket in this account
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : [
          "*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "fivetran" {
  name                = "${var.service}-${var.env}-fivetran-role"
  assume_role_policy  = data.aws_iam_policy_document.fivetran_assume.json
  managed_policy_arns = [aws_iam_policy.fivetran.arn]
}
