module "task" {
  source                       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-task?ref=cn-hermosa-ecs-task-v2.4.0"
  env                          = var.env
  env_inst                     = var.env_inst
  service                      = var.service
  service_id                   = "task"
  cluster_name                 = local.cluster_name
  wait_for_steady_state        = var.wait_for_steady_state
  configuration_secret_arn     = module.secrets.configuration_secret_arn
  task_ecr_repository_uri      = var.task_ecr_repository_uri
  task_container_image_version = var.task_container_image_version
}
