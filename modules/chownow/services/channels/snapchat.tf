## IAM user in Snapchat AWS account to AssumeRole against

module "snapchat_assumerole" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_snapchat ? 1 : 0

  env         = local.env
  name_prefix = "svc_snapchat"
  service     = var.service

  create_access_key = "1"
  user_policy       = data.aws_iam_policy_document.snapchat_assumerole[0].json
}

data "aws_iam_policy_document" "snapchat_assumerole" {
  count = var.enable_snapchat ? 1 : 0

  statement {
    sid       = "SnapchatAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = [local.assumerole_arn]
  }
}

## Testing resources to replicate Snapchat channel workflow
### S3 bucket in ChowNow AWS account to put/get objects

module "cn_snapchat_s3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.snapchat_is_test_env && var.enable_snapchat ? 1 : 0

  bucket_name   = "cn-${var.service}-snapchat-${local.env}"
  env           = var.env
  force_destroy = true
  service       = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule = [
    {
      enabled = true
      expiration = {
        days = local.s3_object_expiration_days
      }
  }]
}

### IAM role in ChowNow AWS account to AssumeRole against

resource "aws_iam_role" "cn_snapchat_assumerole" {
  count = var.snapchat_is_test_env && var.enable_snapchat ? 1 : 0

  name        = "${var.service}-snapchat-test-assumerole-${var.env}"
  description = "Role to be assumed by ${module.snapchat_assumerole[0].iam_user_name} for testing purposes"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = module.snapchat_assumerole[0].iam_user_arn
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cn_snapchat_assumerole_s3" {
  count = var.snapchat_is_test_env && var.enable_snapchat ? 1 : 0

  name = "${var.service}-snapchat-test-s3"
  role = aws_iam_role.cn_snapchat_assumerole[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:DeleteObject"
        ]
        Resource = [
          module.cn_snapchat_s3[0].bucket_arn,
          "${module.cn_snapchat_s3[0].bucket_arn}/*"
        ]
      }
    ]
  })
}
