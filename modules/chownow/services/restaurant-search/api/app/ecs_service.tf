module "ecs_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.4"

  ecs_execution_iam_policy  = data.aws_iam_policy_document.restaurant_search_ecs_execution.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.restaurant_search_ecs_task.json
  ecs_cluster_id            = "${var.service}-${local.env}"
  env                       = var.env
  env_inst                  = var.env_inst
  service                   = var.service
  service_role              = local.service_role
  td_container_definitions  = local.td_full
  app_security_group_ids    = [module.ecs_sg.id]
  custom_vpc_name           = var.vpc_name
  ecs_service_tg_arn        = data.aws_lb_target_group.restaurant_search_api.arn
  ecs_service_desired_count = var.desired_count
  container_name            = local.container_name
  container_port            = local.container_port
  td_cpu                    = var.td_cpu
  td_memory                 = var.td_memory
  enable_execute_command    = true
}

module "ecs_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description = "security group to allow incoming connections from ${var.service} to ${local.env} environment"
  env         = var.env
  env_inst    = var.env_inst
  name_prefix = "ingress"
  service     = var.service
  vpc_id      = data.aws_vpc.private.id

  ingress_tcp_allowed     = [local.container_port]
  enable_egress_allow_all = 1
  cidr_blocks = [
    data.aws_vpc.private.cidr_block
  ]
}
