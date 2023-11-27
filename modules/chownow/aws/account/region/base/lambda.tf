module "function" {
  source       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/deploy?ref=cn-lambda-deploy-v2.1.0"
  count        = var.enable_lambda
  env          = var.env
  env_inst     = var.env_inst
  service_user = local.service_user
}
