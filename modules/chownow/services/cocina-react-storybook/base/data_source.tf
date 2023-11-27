data "aws_ec2_managed_prefix_list" "pritunl_public_ips" {
  filter {
    name   = "prefix-list-name"
    values = ["pritunl-public-ip-list-ops"]
  }
}

data "aws_iam_policy_document" "s3_policy_document" {
  statement {
    sid = "1"

    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3_cocina_react_storybook.arn}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = data.aws_ec2_managed_prefix_list.pritunl_public_ips.entries[*].cidr
    }
  }
}
