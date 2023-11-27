module "ecs_cluster" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/cluster?ref=aws-ecs-cluster-v2.0.0"

  env      = var.env
  env_inst = var.env_inst
  service  = local.app_name
}

module "ecs_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.3"

  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  app_security_group_ids    = [data.aws_security_group.ecs_service_app.id]
  ecs_cluster_id            = module.ecs_cluster.cluster_id
  env                       = var.env
  env_inst                  = var.env_inst
  service                   = local.app_name
  service_role              = "task"
  ecs_service_desired_count = 0
  td_container_definitions  = data.template_file.ecs_td_manage.rendered
  vpc_name_prefix           = var.vpc_name_prefix
  custom_vpc_name           = var.env == "qa" && var.env_inst != "" ? local.env : ""
}

# management task definition for on-demand tasks like migrations
module "ecs_td_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.2"

  env                      = var.env
  env_inst                 = var.env_inst
  service                  = local.app_name
  service_role             = "manage"
  cwlog_group_name         = format("%s-ecs-task-manage-%s", local.app_name, local.env)
  td_container_definitions = data.template_file.ecs_td_manage.rendered
  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
}
