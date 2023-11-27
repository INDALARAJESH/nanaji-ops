module "ecs_service_task" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.5"

  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_service_desired_count = var.task_ecs_service_desired_count
  app_security_group_ids    = [data.aws_security_group.internal.id]
  ecs_cluster_id            = data.aws_ecs_cluster.this.arn
  env                       = var.env
  env_inst                  = var.env_inst
  service                   = var.service
  service_role              = local.service_role
  custom_vpc_name           = var.vpc_name
  enable_execute_command    = var.enable_execute_command
  host_volumes              = local.volumes
  wait_for_steady_state     = var.wait_for_steady_state
  td_cpu                    = var.task_cpu
  td_memory                 = var.task_memory
  td_container_definitions  = local.container_definitions
}
