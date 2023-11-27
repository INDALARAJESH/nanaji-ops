module "web_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description             = "security group to allow incoming connections from ${var.web_name} ${var.service} to ${var.env} environment"
  enable_egress_allow_all = var.enable_egress_allow_all
  env                     = var.env
  ingress_tcp_allowed     = [var.container_port_2]
  name_prefix             = "${var.web_name}-ingress"
  service                 = var.service
  vpc_id                  = data.aws_vpc.selected.id

  cidr_blocks = [data.aws_vpc.selected.cidr_block]
}

# This cannot scale horizontally because there's a redis component built into this container
module "web_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.6"

  app_security_group_ids    = [module.web_sg.id]
  container_name            = local.web_container_name
  container_port            = var.container_port_2
  ecs_cluster_id            = data.aws_ecs_cluster.selected.arn
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_service_tg_arn        = data.aws_lb_target_group.selected_2.arn
  env                       = var.env
  env_inst                  = var.env_inst
  service                   = var.service
  service_role              = var.web_name
  td_container_definitions  = data.template_file.web_td.rendered
  td_cpu                    = var.task_cpu
  td_memory                 = var.task_memory
  vpc_name_prefix           = var.vpc_name_prefix
  ecs_service_desired_count = 1
  alb_tg_hc_path            = "/"
  host_volumes              = local.host_volumes
  runtime_platform          = local.runtime_platform

  enable_execute_command = true
}
