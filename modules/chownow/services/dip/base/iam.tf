module "user_svc_dip" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  env         = var.env
  env_inst    = var.env_inst
  service     = var.service
  user_policy = file("${path.module}/templates/dip_iam_user_policy.json")

  extra_tags = {
    TFModule = var.tag_tfmodule
  }
}
