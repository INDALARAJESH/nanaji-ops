module "task_autoscaling" {
  source       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-autoscaling-cpu-mem?ref=cn-hermosa-ecs-autoscaling-cpu-mem-v2.0.0"
  env          = var.env
  env_inst     = var.env_inst
  service_name = "hermosa-task-${var.env}${var.env_inst}"
  cluster_name = "hermosa-${var.env}${var.env_inst}"
  min_count    = 2
  max_count    = 50
}
