module "hermosa_web_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/web-service?ref=aws-ecs-web-service-v2.1.1"

  depends_on                = [aws_lb_listener_rule.main]
  container_name            = local.web_container_name
  container_port            = var.web_container_port
  ecs_cluster_id            = data.aws_ecs_cluster.this.arn
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_service_desired_count = var.web_ecs_service_desired_count
  ecs_service_tg_arns       = local.target_group_arns
  enable_execute_command    = var.enable_execute_command
  env                       = var.env
  env_inst                  = var.env_inst
  log_retention_in_days     = 30
  service                   = var.service
  service_role              = local.service_role
  custom_vpc_name           = var.vpc_name
  host_volumes              = local.volumes
  app_security_group_ids    = [module.web_sg.id, data.aws_security_group.internal.id]
  wait_for_steady_state     = var.wait_for_steady_state
  td_cpu                    = var.task_cpu
  td_memory                 = var.task_memory
  td_container_definitions  = local.container_definitions
}
