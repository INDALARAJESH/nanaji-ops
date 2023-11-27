##############
# Public ALB #
##############

# Security group for application load balancer
module "alb_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.0"

  description = "security group to allow incoming connections from ${var.service} to ${local.env} environment"
  env         = var.env
  env_inst    = var.env_inst
  name_prefix = "ingress"
  service     = var.service
  vpc_id      = data.aws_vpc.selected.id
  cidr_blocks = [data.aws_vpc.selected.cidr_block]

  ingress_tcp_allowed = var.alb_ingress_tcp_allowed
}

# Security group rule that allows all inbound ICMP traffic
# This allows traffic such at ping trace route, etc.
resource "aws_security_group_rule" "ingress_self_all_icmp" {
  type              = "ingress"
  security_group_id = module.alb_sg.id
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  self              = true
}

# Security group rule that allows all outbound traffic
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  security_group_id = module.alb_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Public application load balancer
# will allow inbound traffic from VPN
module "public_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.0"

  alb_log_bucket             = var.alb_log_bucket
  access_logs_enabled        = var.alb_logs_enabled
  certificate_arn            = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_alb        = "${var.service}-origin"
  cname_subdomain_cloudflare = var.service
  env                        = var.env
  service                    = var.service
  vpc_id                     = data.aws_vpc.selected.id

  security_group_ids = [data.aws_security_group.ingress_vpn_allow.id, data.aws_security_group.ingress_cloudflare.id, module.alb_sg.id]
}

# 80 Target group for appsmith containers
module "public_tg_3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.0"

  alb_name              = module.public_alb.alb_name
  alb_listener_protocol = var.alb_tg_listener_protocol
  alb_tg_target_type    = var.alb_tg_target_type
  env                   = var.env
  env_inst              = var.env_inst
  tg_port               = var.container_port_2
  health_check_target   = var.tg_health_check_target
  service               = var.service
  vpc_id                = data.aws_vpc.selected.id
}

# Listener rule which matches on the host header SERVICENAMEGOESHERE.ENV.svpn.chownow.com from
# TCP 443 and forwards them to the 80 target group on TCP port
module "public_listener_rule_default" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.0.1"

  env                    = var.env
  env_inst               = var.env_inst
  listener_arn           = module.public_alb.listener_arn
  listener_rule_priority = 10
  host_header_values     = local.host_header
  service                = var.service
  target_group_arn       = module.public_tg_3.tg_arn

}
