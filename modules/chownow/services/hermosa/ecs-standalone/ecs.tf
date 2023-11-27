module "web_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description             = "security group to allow incoming connections from ${local.web_container_name} ${var.service} to ${var.env} environment"
  enable_egress_allow_all = var.enable_egress_allow_all
  env                     = var.env
  env_inst                = var.env_inst
  ingress_tcp_allowed     = [var.web_container_port]
  name_prefix             = "${local.web_container_name}-ingress"
  service                 = var.service
  vpc_id                  = data.aws_vpc.selected.id

  cidr_blocks = [data.aws_vpc.selected.cidr_block]
}

module "hermosa_web_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/web-service?ref=aws-ecs-web-service-v2.1.1"

  container_name            = local.web_container_name
  container_port            = var.web_container_port
  ecs_cluster_id            = data.aws_ecs_cluster.existing.arn
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_service_desired_count = var.web_ecs_service_desired_count
  ecs_service_tg_arns       = [module.alb_ecs_tg.tg_arn]
  depends_on                = [aws_lb_listener_rule.main]
  env                       = var.env
  env_inst                  = var.env_inst
  log_retention_in_days     = 30
  service                   = local.service
  service_role              = ""
  td_container_definitions  = data.template_file.full_td.rendered
  custom_vpc_name           = local.vpc_name
  host_volumes              = []
  app_security_group_ids    = [module.web_sg.id]
  vpc_name_prefix           = var.vpc_name_prefix
  wait_for_steady_state     = true
  td_cpu                    = var.task_cpu
  td_memory                 = var.task_memory
}
