module "alb_web" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.4"

  count = var.enable_alb_web

  access_logs_enabled = false
  env                 = var.env
  env_inst            = var.env_inst
  service             = local.service
  vpc_id              = data.aws_vpc.selected.id

  # alb
  security_group_ids = [
    data.aws_security_group.ingress_vpn_allow.id,
  ]

  # listener
  certificate_arn = data.aws_acm_certificate.public.arn
}

# ALB target group that ECS service will attach to once deployed
module "alb_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  count = var.enable_alb_web

  alb_listener_protocol = var.alb_tg_listener_protocol
  alb_name              = module.alb_web[0].alb_name
  alb_tg_target_type    = var.alb_tg_target_type
  deregistration_delay  = var.alb_tg_deregistration_delay
  env                   = var.env
  env_inst              = var.env_inst
  service               = var.service
  tg_port               = var.container_web_port
  vpc_id                = data.aws_vpc.selected.id

  health_check_healthy_threshold = var.tg_health_check_healthy_threshold
  health_check_interval          = var.tg_health_check_interval
  health_check_target            = var.tg_health_check_target
  health_check_timeout           = var.tg_health_check_timeout
}

# ALB Listener Rule that allows host header matches of `menu.ENV.svpn.chownow.com`
module "alb_listener_rule_default" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.2"

  count = var.enable_alb_web

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.alb_web[0].listener_arn
  listener_rule_priority = 10
  host_header_values     = ["${var.service}.${local.dns_zone}"]
  service                = var.service
  target_group_arn       = module.alb_tg[0].tg_arn
}

module "alb_cname" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"

  count = var.enable_alb_web

  name    = "${local.service}.${local.dns_zone}"
  zone_id = data.aws_route53_zone.public.zone_id
  type    = "CNAME"
  records = [module.alb_web[0].alb_dns_name]
}
