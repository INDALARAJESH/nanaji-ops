module "rds_s3" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/db?ref=cn-menu-rds_s3-v2.0.1"
  env      = var.env
  env_inst = var.env_inst
}
