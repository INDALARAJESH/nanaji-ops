module "configuration" {
  source                       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-configuration?ref=cn-hermosa-ecs-configuration-v2.0.0"
  env                         = var.env
  env_inst                    = var.env_inst
  service                     = var.service
}
