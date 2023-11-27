# ---------------------------------------------------------------------------------------------------------------------
# HERMOSA IAM APP USER
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "hermosa_user" {
  statement {
    sid = "HermosaUserSNSAccess"

    actions = [
      "sns:GetPlatformApplicationAttributes",
      "sns:ListPlatformApplications",
      "sns:CreatePlatformEndpoint",
      "sns:CreatePlatformApplication",
      "sns:DeletePlatformApplication",
      "sns:Publish",
      "sns:Subscribe",
      "sns:Unsubscribe",
      "sns:CreateTopic",
    ]

    resources = [
      "arn:aws:sns:${local.region}:${local.account_id}:${var.service}-redis-${local.env}",
      "arn:aws:sns:${local.region}:${local.account_id}:${var.service}-redis-${local.env}-pagerduty",
      "arn:aws:sns:${local.region}:${local.account_id}:${var.service}-es-${local.env}-pagerduty",
    ]
  }

}

module "user_svc_hermosa" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.3"
  count  = var.enable_iam_user

  custom_path     = local.custom_username_path
  env             = var.env
  env_inst        = var.env_inst
  custom_username = local.custom_username
  service         = var.service
  user_policy     = data.aws_iam_policy_document.hermosa_user.json
}

# ---------------------------------------------------------------------------------------------------------------------
# HERMOSA IAM APP USER CLOUDFRONT PERMISSIONS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_user_policy_attachment" "hermosa_user_cloudfront_bucket_access" {
  count      = var.enable_cloudfront_distribution
  user       = module.user_svc_hermosa[count.index].iam_user_name
  policy_arn = aws_iam_policy.hermosa_user_cloudfront_bucket_access[count.index].arn
}

resource "aws_iam_policy" "hermosa_user_cloudfront_bucket_access" {
  count  = var.enable_cloudfront_distribution
  name   = "${local.name_prefix}-hermosa-cloudfront-bucket-access-${local.env}"
  path   = "/"
  policy = data.aws_iam_policy_document.hermosa_user_cloudfront_bucket_access[count.index].json
}

data "aws_iam_policy_document" "hermosa_user_cloudfront_bucket_access" {
  count = var.enable_cloudfront_distribution

  statement {
    sid = "CreateCFInvalidation"

    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
    ]

    resources = [
      module.cloudfront[count.index].arn,
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# HERMOSA IAM APP USER S3 PERMISSIONS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_user_policy_attachment" "hermosa_user_s3_bucket_access" {
  count      = local.enable_s3_iam_permissions
  user       = module.user_svc_hermosa[count.index].iam_user_name
  policy_arn = aws_iam_policy.hermosa_user_s3_bucket_access[count.index].arn
}

resource "aws_iam_policy" "hermosa_user_s3_bucket_access" {
  count  = local.enable_s3_iam_permissions
  name   = "${local.name_prefix}-hermosa-s3-bucket-access-${local.env}"
  path   = "/"
  policy = data.aws_iam_policy_document.hermosa_user_s3_bucket_access[count.index].json
}

data "aws_iam_policy_document" "hermosa_user_s3_bucket_access" {
  count = local.enable_s3_iam_permissions
  statement {
    sid = "HermosaUserS3BucketAccess"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_google_datafeed}",
      "arn:aws:s3:::${local.bucket_merchant}",
      "arn:aws:s3:::${local.bucket_onboarding}",
      "arn:aws:s3:::${local.bucket_static_assets}",
      "arn:aws:s3:::${local.bucket_facebook}",
      "arn:aws:s3:::${local.bucket_single_platform}",
      "arn:aws:s3:::${local.bucket_audit}",
      "arn:aws:s3:::${local.bucket_menu}"
    ]
  }

  statement {
    sid = "HermosaUserS3BucketObjectAccess"

    actions = [
      "s3:HeadBucket",
      "s3:HeadObject",
      "s3:ListObjects",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_google_datafeed}/*",
      "arn:aws:s3:::${local.bucket_merchant}/*",
      "arn:aws:s3:::${local.bucket_onboarding}/*",
      "arn:aws:s3:::${local.bucket_static_assets}/*",
      "arn:aws:s3:::${local.bucket_facebook}/*",
      "arn:aws:s3:::${local.bucket_single_platform}/*",
      "arn:aws:s3:::${local.bucket_audit}/*",
      "arn:aws:s3:::${local.bucket_menu}/*"
    ]
  }
}
