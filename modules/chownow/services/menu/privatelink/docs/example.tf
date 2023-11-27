module "privatelink" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/privatelink?ref=cn-menu-privatelink-v2.0.4"
  env      = var.env
  env_inst = var.env_inst
}
