### mparticle lamnbda user

module "user_svc_mparticle" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.1"

  env         = var.env
  env_inst    = var.env_inst
  service     = var.service
  user_policy = templatefile("${path.module}/templates/mparticle_iam_user_policy.json", { region = data.aws_region.current.name })
}
