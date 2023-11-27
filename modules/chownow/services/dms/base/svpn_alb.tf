# this ALB accepts "internal" (vpc-local, or vpn source IP, traffic only)
# public integrations with delivery providers go through cloudflare_alb.tf

###########
# DMS ALB #
###########

resource "aws_security_group_rule" "alb_public_allow_vpc_https" {
  count = var.enable_alb_public

  description       = "allow ${local.vpc_name} HTTPS access to ${module.alb_public[0].alb_name}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${data.aws_nat_gateway.selected.public_ip}/32"]
  security_group_id = module.alb_public[0].alb_sg_id
}
module "alb_public" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.7"
  count  = var.enable_alb_public

  access_logs_enabled = var.alb_logs_enabled
  certificate_arn     = data.aws_acm_certificate.star_chownow.arn
  env                 = var.env
  env_inst            = var.env_inst
  service             = var.service
  vpc_id              = data.aws_vpc.selected.id

  security_group_ids = [data.aws_security_group.ingress_vpn_allow.id]
}

# ALB target group assigned to the web service created in the ECS base module
module "alb_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  count = var.enable_alb_public

  alb_listener_protocol = var.alb_tg_listener_protocol
  alb_name              = module.alb_public[0].alb_name
  alb_tg_target_type    = var.alb_tg_target_type
  deregistration_delay  = local.env == "ncp" ? var.alb_tg_deregistration_delay : 1
  env                   = var.env
  env_inst              = var.env_inst
  service               = var.service
  tg_port               = var.container_port
  vpc_id                = data.aws_vpc.selected.id

  health_check_healthy_threshold = local.env == "ncp" ? var.tg_health_check_healthy_threshold : 2
  health_check_interval          = local.env == "ncp" ? var.tg_health_check_interval : 5
  health_check_target            = var.tg_health_check_target
  health_check_timeout           = local.env == "ncp" ? var.tg_health_check_timeout : 2
}

# ALB Listener Rule that allows host header matches of `dms.ENV.svpn.chownow.com`
module "alb_listener_rule_default" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.2"

  count = var.enable_alb_public

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.alb_public[0].listener_arn
  listener_rule_priority = 10
  host_header_values     = ["${var.service}.${local.dns_zone}"]
  service                = var.service
  target_group_arn       = module.alb_tg[0].tg_arn
}

###############
# DMS ALB DNS #
###############

# CNAME to map `dms.ENV.svpn.chownow.com` to the amazon provided public DNS record for the ALB
module "alb_cname" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  count = var.enable_alb_public

  name    = "${var.service}.${local.dns_zone}."
  zone_id = data.aws_route53_zone.public.zone_id
  type    = "CNAME"
  records = [module.alb_public[0].alb_dns_name]
}

# CNAME created in the private svpn zone of the non-prod "Primary" VPCs
# Cannot use the route53 record module because of the race condition that
# is created when it tries to interpolate the data source lookup that
# doesn't exist (when ran in NCP)
resource "aws_route53_record" "alb_cname_primary_vpc_dms" {
  count   = var.env == "ncp" ? 0 : 1
  name    = "${var.service}.${local.dns_zone}."
  records = [module.alb_public[0].alb_dns_name]
  type    = "CNAME"
  ttl     = var.alb_cname_primary_vpc_svpn_ttl
  zone_id = data.aws_route53_zone.primary_vpc_svpn_private[0].zone_id
}
