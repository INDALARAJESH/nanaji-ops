##################################
# Public Marketplace Builder ALB #
##################################

# Public application load balancer, will allow inbound traffic from VPN and Cloudflare
module "public_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.7"

  custom_alb_log_bucket      = var.custom_alb_log_bucket
  access_logs_enabled        = var.alb_logs_enabled
  certificate_arn            = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_alb        = "${var.service}-origin"
  cname_subdomain_cloudflare = local.env == "prod" ? "eat" : var.service
  env                        = var.env
  env_inst                   = var.env_inst
  service                    = var.service
  vpc_id                     = data.aws_vpc.selected.id
  extra_tags                 = local.common_tags

  security_group_ids = [data.aws_security_group.ingress_vpn_allow.id, data.aws_security_group.ingress_cloudflare.id]
}

# Target group for Marketplace instance(s) and responds on TCP 80
module "public_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.0"

  alb_name              = module.public_alb.alb_name
  alb_listener_protocol = var.alb_tg_listener_protocol
  alb_tg_target_type    = var.alb_tg_target_type
  env                   = var.env
  env_inst              = var.env_inst
  tg_port               = var.marketplace_container_port
  health_check_target   = var.tg_health_check_target
  health_check_timeout  = var.health_check_timeout
  health_check_interval = var.health_check_interval
  service               = var.service
  vpc_id                = data.aws_vpc.selected.id
  extra_tags            = local.common_tags
}

# Listener rule which matches on the host header marketplace.ENV.svpn.chownow.com from
# TCP 443 and forwards them to the above target group on TCP 80
module "public_listener_rule_default" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.4"

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.public_alb.listener_arn
  listener_rule_priority = 10
  host_header_values     = local.host_header
  service                = var.service
  target_group_arns      = [module.public_tg.tg_arn]
  extra_tags             = local.common_tags

  depends_on = [module.public_alb.listener_arn, module.public_tg.tg_arn]
}

# Security group rule that allows all inbound ICMP traffic
# This allows traffic such as ping, traceroute, etc.
resource "aws_security_group_rule" "ingress_self_all_icmp" {
  type              = "ingress"
  security_group_id = module.public_alb.alb_sg_id
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  self              = true
}
