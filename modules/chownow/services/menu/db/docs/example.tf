module "db" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/db?ref=cn-menu-db-v2.0.10"
  env      = var.env
  env_inst = var.env_inst
}
