# Rewards Network S3 resource(s)

module "rewards_network_s3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.0"

  count = var.enable_rewards_network ? 1 : 0

  bucket_name = "cn-${var.service}-rewards-network-${local.env}"
  env         = local.env
  service     = var.service

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

data "aws_iam_policy_document" "rewards_network_s3_bucket_policy" {
  count = var.enable_rewards_network ? 1 : 0

  statement {
    sid = "AllowRewardsNetworkS3Access"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
    ]
    resources = [
      module.rewards_network_s3[0].bucket_arn,
      "${module.rewards_network_s3[0].bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.rewards_network_s3_principals
    }
  }
}

resource "aws_s3_bucket_policy" "rewards_network_s3" {
  count = var.enable_rewards_network ? 1 : 0

  bucket = module.rewards_network_s3[0].bucket_name
  policy = data.aws_iam_policy_document.rewards_network_s3_bucket_policy[0].json

  # Needed to get around race condition:
  # `OperationAborted: A conflicting conditional operation is currently in progress against this resource. Please try again.`
  # This resource should wait until module.rewards_network_s3.aws_s3_bucket_public_access_block[0].bucket is created
  depends_on = [module.rewards_network_s3]
}

# Rewards Network IAM resource(s)

module "rewards_network_iam" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_rewards_network ? 1 : 0

  env         = local.env
  name_prefix = "svc_rewards_network"
  service     = var.service

  create_access_key = "1"
  user_policy       = data.aws_iam_policy_document.rewards_network_iam[0].json
}

data "aws_iam_policy_document" "rewards_network_iam" {
  count = var.enable_rewards_network ? 1 : 0

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:DeleteObject"
    ]
    resources = [
      module.rewards_network_s3[0].bucket_arn,
      "${module.rewards_network_s3[0].bucket_arn}/*"
    ]
  }
}
