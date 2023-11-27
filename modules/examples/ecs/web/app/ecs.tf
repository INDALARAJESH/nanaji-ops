module "web_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description             = "security group to allow incoming connections from ${var.web_name} ${var.service} to ${var.env} environment"
  enable_egress_allow_all = var.enable_egress_allow_all
  env                     = var.env
  ingress_tcp_allowed     = [var.container_port]
  name_prefix             = "${var.web_name}-ingress"
  service                 = var.service
  vpc_id                  = data.aws_vpc.selected.id

  cidr_blocks = [data.aws_vpc.selected.cidr_block]
}

module "web_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.3"

  app_security_group_ids   = [module.web_sg.id]
  container_name           = local.web_container_name
  container_port           = var.container_port
  ecs_cluster_id           = data.aws_ecs_cluster.selected.arn
  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_service_tg_arn       = data.aws_lb_target_group.selected.arn
  env                      = var.env
  env_inst                 = var.env_inst
  service                  = var.service
  service_role             = var.web_name
  td_container_definitions = data.template_file.web_td.rendered
  vpc_name_prefix          = var.vpc_name_prefix
}

# ECS web autoscaling
module "web_autoscale" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.0.1"

  env                      = var.env
  env_inst                 = var.env_inst
  min_capacity             = local.env == var.production_environment_name ? var.web_scaling_min_capacity : 1
  max_capacity             = local.env == var.production_environment_name ? var.web_scaling_max_capacity : 3
  policy_scale_in_cooldown = local.env == var.production_environment_name ? var.web_policy_scale_in_cooldown : 1
  policy_target_conditions = var.policy_target_conditions
  service                  = var.service
  target_resource_id       = "service/${local.cluster_name}/${module.web_service.service_name}"
}
