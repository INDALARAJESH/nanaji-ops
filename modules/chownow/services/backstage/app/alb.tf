module "svpn_alb" {
  source                       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/svpn-alb?ref=svpn-alb-v2.0.3"
  env                          = var.env
  env_inst                     = ""
  service                      = var.service
  vpc_name_prefix              = var.vpc_name_prefix
  security_group_name_override = "${var.vpc_name_prefix}-vpn-sg-${var.env}"
}

module "alb_ecs_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  env     = var.env
  service = var.service
  vpc_id  = data.aws_vpc.main.id

  # Target Group
  alb_listener_protocol = "HTTP"
  alb_name              = module.svpn_alb.alb_name
  alb_tg_target_type    = "ip"
  deregistration_delay  = 30
  health_check_target   = "/"
  health_check_interval = 15
  tg_port               = var.container_port
}

module "alb_ecs_listener_rule" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.2"

  env     = var.env
  service = var.service

  # Listener Rule
  listener_arn     = module.svpn_alb.listener_arn
  target_group_arn = module.alb_ecs_tg.tg_arn

  host_header_values = ["*.${var.domain_public}"]
}

## backstage. CNAME
module "alb_service_r53_cname" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  name    = "${var.service}.${var.env}.${var.domain_public}."
  zone_id = data.aws_route53_zone.public.zone_id
  ttl     = var.dns_ttl
  type    = "CNAME"
  records = [module.svpn_alb.alb_dns_name]
}