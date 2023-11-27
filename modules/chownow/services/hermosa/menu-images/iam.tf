resource "aws_s3_bucket_policy" "menuimages" {
  bucket = module.cn_menuimages.bucket_name
  policy = data.aws_iam_policy_document.menuimages_s3_read_cloudflare_only.json
}

# IAM user with access to the bucket
module "svc_menuimages_user" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.3"

  env               = var.env
  env_inst          = var.env_inst
  service           = "menuimages"
  create_access_key = 1
  user_policy       = data.aws_iam_policy_document.menuimages_s3_policy_document.json
}
