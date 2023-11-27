# Sherlock ALB Security Group

module "alb_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/security-group?ref=aws-security-group-v1.0.1"

  description             = "${upper(var.service)} Public ALB default security group"
  enable_egress_allow_all = "${var.alb_enable_egress_allow_all}"
  env                     = "${var.env}"
  env_inst                = "${var.env_inst}"
  ingress_tcp_allowed     = ["${var.alb_ingress_tcp_allowed}"]
  name_prefix             = "${var.alb_name_prefix}"
  service                 = "${var.service}"
  vpc_id                  = "${data.aws_vpc.selected.id}"

  cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
}

# Sherlock ALB
module "alb_public" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/lb/alb/public?ref=alb-public-v1.1.5"

  alb_log_bucket      = "${var.alb_log_bucket}"
  access_logs_enabled = "${var.alb_logs_enabled}"
  certificate_arn     = "${data.aws_acm_certificate.star_chownow.arn}"
  env                 = "${var.env}"
  env_inst            = "${var.env_inst}"
  service             = "${var.service}"
  vpc_id              = "${data.aws_vpc.selected.id}"

  security_group_ids = [
    "${data.aws_security_group.ingress_vpn_allow.id}",
    "${module.alb_sg.id}",
  ]
}

# ALB target group assigned to the web service created in the ECS base module
module "alb_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/lb/alb/target-group?ref=alb-tg-v1.0.2"

  alb_listener_protocol = "${var.alb_tg_listener_protocol}"
  alb_name              = "${module.alb_public.alb_name}"
  alb_tg_target_type    = "${var.alb_tg_target_type}"
  env                   = "${var.env}"
  env_inst              = "${var.env_inst}"
  health_check_target   = "${var.tg_health_check_target}"
  service               = "${var.service}"
  tg_port               = "${var.container_port}"
  vpc_id                = "${data.aws_vpc.selected.id}"
}

# ALB Listener Rule that allows host header matches of `sherlock.ENV.svpn.chownow.com`
module "alb_listener_rule_default" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/lb/alb/listener-rule?ref=alb-listener-rule-v1.0.0"

  env                    = "${var.env}"
  env_inst               = "${var.env_inst}"
  listener_arn           = "${module.alb_public.listener_arn}"
  listener_rule_priority = 10
  host_header_values     = ["${var.service}.${local.dns_zone}"]
  service                = "${var.service}"
  target_group_arn       = "${module.alb_tg.tg_arn}"
}

# CNAME to map `sherlock.ENV.svpn.chownow.com` to the amazon provided public DNS record for the ALB
module "alb_cname" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/route53/record/basic?ref=r53-record-basic-v1.0.0"

  name    = "${var.service}.${local.dns_zone}."
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  type    = "CNAME"
  records = ["${module.alb_public.alb_dns_name}"]
}
