# Errbot ECS Service
module "errbot_ecs_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.7"

  app_security_group_ids    = [data.aws_security_group.internal.id]
  custom_vpc_name           = local.env
  ecs_cluster_id            = data.aws_ecs_cluster.selected.arn
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_service_desired_count = 1
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  enable_execute_command    = var.enable_execute_command
  env                       = var.env
  service                   = var.service
  service_role              = "service"
  td_container_definitions  = local.td_container_definitions

}
