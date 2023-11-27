module "base" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/base?ref=cn-menu-base-v2.0.2"
  env             = var.env
  env_inst        = var.env_inst
  vpc_name_prefix = var.vpc_name_prefix
}
