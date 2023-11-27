module "secrets" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-configuration?ref=cn-hermosa-ecs-configuration-v2.1.0"
  env     = var.env
  service = var.service
}
