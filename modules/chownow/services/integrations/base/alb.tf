## Public ALB Resources
module "alb_public" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.3"
  count  = var.enable_alb

  env      = var.env
  env_inst = var.env_inst
  service  = local.service
  vpc_id   = data.aws_vpc.selected.id

  # Access Logs
  access_logs_enabled   = false
  custom_alb_log_bucket = local.alb_log_bucket

  # Certificate
  certificate_arn = data.aws_acm_certificate.public.arn

  security_group_ids = [
    data.aws_security_group.vpn_sg.id,
    data.aws_security_group.ingress_cloudflare.id,
  ]
}

module "alb_ecs_listener_rule_main" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.2"
  count                  = var.enable_canary
  env                    = local.env
  service                = local.service
  listener_arn           = local.alb_listener_arn
  listener_rule_priority = var.listener_rule_priority + 10
  weighted_target_groups = [
    {
      target_group_arn = local.target_group_arn_blue
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
    },
    {
      target_group_arn = module.alb_ecs_tg_green[0].tg_arn
      weight           = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
    }
  ]

  host_header_values = concat(
    var.alb_addtl_hosts,
    list("${local.service}.${local.env}.${var.domain_public}")
  )
}
module "alb_ecs_listener_rule_blue" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.2"
  count                  = var.enable_canary
  env                    = local.env
  service                = local.service
  listener_arn           = local.alb_listener_arn
  listener_rule_priority = var.listener_rule_priority + 20
  target_group_arns      = [local.target_group_arn_blue]
  host_header_values = [
    "${local.service}-blue.${local.env}.${var.domain_public}"
  ]
}
module "alb_ecs_listener_rule_green" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.2"
  count                  = var.enable_canary
  env                    = local.env
  service                = local.service
  listener_arn           = local.alb_listener_arn
  listener_rule_priority = var.listener_rule_priority + 30
  target_group_arns      = [module.alb_ecs_tg_green[0].tg_arn]
  host_header_values = [
    "${local.service}-green.${local.env}.${var.domain_public}"
  ]
}
