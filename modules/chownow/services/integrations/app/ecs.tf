module "ecs_base_web" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/base?ref=aws-ecs-base-v2.1.5"

  container_name            = local.web_container_name
  container_port            = var.web_container_port
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_service_desired_count = var.web_ecs_service_desired_count
  ecs_service_tg_arn        = data.aws_lb_target_group.main.arn
  env                       = var.env
  env_inst                  = var.env_inst
  log_retention_in_days     = 30
  service                   = local.full_service
  service_role              = "web"
  td_container_definitions  = data.template_file.web_td.rendered
  vpc_name_prefix           = var.vpc_name_prefix
  td_cpu                    = var.td_cpu
  td_memory                 = var.td_memory
}

module "ecs_task_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.4"

  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  env                      = var.env
  env_inst                 = var.env_inst
  service                  = local.full_service
  service_role             = "manage"
  td_container_definitions = data.template_file.manage_td.rendered
  host_volumes             = []
}

module "ecs_base_autoscale" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.0.1"

  env                = local.env
  service            = local.full_service
  min_capacity       = var.web_ecs_service_desired_count
  max_capacity       = var.web_ecs_service_max_count
  target_resource_id = "service/${module.ecs_base_web.cluster_name}/${module.ecs_base_web.service_name}"
}
