module "user_svc_appbuilder" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v3.0.0"

  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  service     = "${var.custom_name}"
  user_policy = templatefile("${path.module}/templates/appbuilder_iam_user_policy.json.tpl", { s3_bucket_arn = module.appbuilder_s3.bucket_arn })
}
