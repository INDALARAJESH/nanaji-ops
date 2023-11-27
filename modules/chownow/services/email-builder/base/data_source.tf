data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# https://aws.amazon.com/premiumsupport/knowledge-center/s3-aws-ip-addresses-access/
data "aws_iam_policy_document" "emailbuilder_s3_read_cloudflare_only" {
  statement {
    sid       = "AllowGetObjectCloudflare"
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${module.cn_emailbuilder.bucket_arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cloudflare_allow_ips
    }
  }
}

# Policy doc for access to the bucket by app, for puts/deletes
data "aws_iam_policy_document" "emailbuilder_s3_policy_document" {
  statement {
    sid = "emailbuilders3access"

    actions = [
      "s3:Put*",
      "s3:Get*",
      "s3:List*",
      "s3:DeleteObject",
    ]

    resources = [
      module.cn_emailbuilder.bucket_arn,
      "${module.cn_emailbuilder.bucket_arn}/*",
    ]
  }
}

# Chownowcdn delegated zone
data "aws_route53_zone" "chownowcdn_dot_com" {
  count        = local.is_not_prod
  name         = "${local.environment_domain}."
  private_zone = false
}
