# IAM user for third party Seated bucket

module "user_svc_seated" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_seated_external ? 1 : 0

  env         = var.env
  name_prefix = "svc_seated"
  service     = var.service
  user_policy = data.aws_iam_policy_document.svc_seated_policy.json
}

data "aws_iam_policy_document" "svc_seated_policy" {

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${local.seated_s3_bucket_name}",
      "arn:aws:s3:::${local.seated_s3_bucket_name}/*"
    ]
  }
}

# OPS-2789  Internal Seated S3 bucket resources

module "cn_seated_s3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  count = var.enable_seated ? 1 : 0

  bucket_name = local.cn_seated_s3_bucket_name
  env         = var.env
  env_inst    = var.env_inst
  service     = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}

# OPS-2789 Internal Seated service user

module "cn_user_svc_seated_channels" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.1"

  count = var.enable_seated ? 1 : 0

  env         = var.env
  name_prefix = "svc_cn"
  service     = "seated_channels"
  user_policy = data.aws_iam_policy_document.cn_svc_seated_policy.json
}

data "aws_iam_policy_document" "cn_svc_seated_policy" {

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${local.cn_seated_s3_bucket_name}",
      "arn:aws:s3:::${local.cn_seated_s3_bucket_name}/*"
    ]
  }
}
