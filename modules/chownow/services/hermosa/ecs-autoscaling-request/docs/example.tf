module "api_autoscaling" {
  source                   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-autoscaling-cpu-mem?ref=cn-hermosa-ecs-autoscaling-request-v2.0.0"
  env                      = var.env
  env_inst                 = var.env_inst
  service_name             = "hermosa-api-${var.env}${var.env_inst}"
  cluster_name             = "hermosa-${var.env}${var.env_inst}"
  min_count                = 2
  max_count                = 50
  alb_name                 = var.alb_name
  target_group_name        = var.target_group_name
  request_count_per_target = 700
}
