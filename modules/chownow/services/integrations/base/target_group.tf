module "alb_ecs_tg_blue" {
  source                = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"
  count                 = var.target_group_arn_blue == "" ? var.enable_canary : 0
  env                   = local.env
  service               = local.service
  target_group_name     = "${local.alb_name}-blue"
  vpc_id                = data.aws_vpc.selected.id
  alb_listener_protocol = "HTTP"
  alb_name              = local.alb_name
  alb_tg_target_type    = "ip"
  deregistration_delay  = var.web_container_deregistration_delay
  health_check_target   = var.web_container_healthcheck_target
  health_check_interval = var.web_container_healthcheck_interval
  tg_port               = var.web_container_port
}

module "alb_ecs_tg_green" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  count                 = var.enable_canary
  env                   = local.env
  service               = local.service
  target_group_name     = "${local.alb_name}-green"
  vpc_id                = data.aws_vpc.selected.id
  alb_listener_protocol = "HTTP"
  alb_name              = local.alb_name
  alb_tg_target_type    = "ip"
  deregistration_delay  = var.web_container_deregistration_delay
  health_check_target   = var.web_container_healthcheck_target
  health_check_interval = var.web_container_healthcheck_interval
  tg_port               = var.web_container_port
}
