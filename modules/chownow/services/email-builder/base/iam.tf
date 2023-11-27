resource "aws_s3_bucket_policy" "emailbuilder" {
  bucket = module.cn_emailbuilder.bucket_name
  policy = data.aws_iam_policy_document.emailbuilder_s3_read_cloudflare_only.json
}

# IAM user with access to the bucket
module "svc_emailbuilder_user" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.2"

  env         = var.env
  service     = "emailbuilder"
  user_policy = data.aws_iam_policy_document.emailbuilder_s3_policy_document.json
}
