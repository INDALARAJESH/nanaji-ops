module "marketplace_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/marketplace/app?ref=cn-marketplace-app-v2.1.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
