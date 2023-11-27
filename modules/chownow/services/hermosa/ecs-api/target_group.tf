module "alb_ecs_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  env               = var.env
  env_inst          = var.env_inst
  service           = local.service_full
  target_group_name = local.target_group_name
  vpc_id            = data.aws_vpc.selected.id

  # Target Group
  alb_listener_protocol = "HTTPS"
  alb_name              = data.aws_lb.alb.name
  alb_tg_target_type    = "ip"
  deregistration_delay  = var.web_container_deregistration_delay
  health_check_timeout  = var.web_container_healthcheck_timeout
  health_check_target   = var.web_container_healthcheck_target
  health_check_interval = var.web_container_healthcheck_interval
  tg_port               = var.web_container_port
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = data.aws_lb_listener.alb.arn

  priority = var.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = module.alb_ecs_tg.tg_arn
  }

  condition {
    host_header {
      values = length(var.cloudflare_hostnames) > 0 ? var.cloudflare_hostnames : var.alb_hostnames
    }
  }
}

resource "aws_route53_record" "alb" {
  count = length(var.alb_hostnames)

  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.alb_hostnames[count.index]
  type    = "CNAME"
  ttl     = "300"
  records = ["${data.aws_lb.alb.dns_name}."]
}

resource "aws_route53_record" "cloudflare" {
  count = length(var.cloudflare_hostnames)

  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.cloudflare_hostnames[count.index]
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.cloudflare_hostnames[count.index]}.${var.cloudflare_domain}"]
}

