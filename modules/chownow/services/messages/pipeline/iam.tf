data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "${var.topic_base_name}-firehose-role-${local.env}"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "aws_iam_policy_document" "firehose_s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      module.cn_events_firehose_s3.bucket_arn,
      "${module.cn_events_firehose_s3.bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_s3" {
  name   = "${var.topic_base_name}-firehose-policy-${local.env}"
  role   = aws_iam_role.firehose_role.id
  policy = data.aws_iam_policy_document.firehose_s3.json
}

data "aws_iam_policy_document" "sns_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose_sns_role" {
  name               = "${var.topic_base_name}-firehose-sns-role-${local.env}"
  assume_role_policy = data.aws_iam_policy_document.sns_assume_role.json
}

data "aws_iam_policy_document" "firehose_sns" {
  statement {
    effect = "Allow"

    actions = [
      "firehose:DescribeDeliveryStream",
      "firehose:ListDeliveryStreams",
      "firehose:ListTagsForDeliveryStream",
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]

    resources = [
      "arn:aws:firehose:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deliverystream/${local.firehose_delivery_stream_name}"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_sns" {
  name   = "${var.topic_base_name}-firehose-sns-policy-${local.env}"
  role   = aws_iam_role.firehose_sns_role.id
  policy = data.aws_iam_policy_document.firehose_sns.json
}
