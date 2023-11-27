##############
# Public ALB #
##############
resource "aws_lb" "public" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = concat(var.security_group_ids, [aws_security_group.default.id])
  subnets            = data.aws_subnets.public.ids

  access_logs {
    bucket  = local.alb_log_bucket
    enabled = var.access_logs_enabled
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.alb_name
    "NetworkType" = "public" }
  )
}

###############################
# Fixed-Response ALB Listener #
###############################
resource "aws_alb_listener" "fixed-response" {
  count = var.listener_da_type == "fixed-response" ? 1 : 0

  load_balancer_arn = aws_lb.public.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = var.listener_da_type

    fixed_response {
      content_type = var.listener_da_fixed_content_type
      status_code  = var.listener_da_fixed_status_code
      message_body = var.listener_da_fixed_message_body
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

###########################
# Forwarding ALB Listener #
###########################

resource "aws_lb_target_group" "forward" {
  count = var.listener_da_type == "forward" ? 1 : 0

  name        = "${aws_lb.public.name}-${lower(local.tg_port)}"
  port        = local.tg_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id
  target_type = var.tg_target_type

  health_check {
    path     = var.health_check_target
    protocol = var.tg_protocol
    matcher  = var.health_check_matcher
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${aws_lb.public.name}-${lower(local.tg_port)}",
    }
  )
}

resource "aws_alb_listener" "forward" {
  count = var.listener_da_type == "forward" ? 1 : 0

  load_balancer_arn = aws_lb.public.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = var.listener_da_type
    target_group_arn = aws_lb_target_group.forward.0.arn
  }

  depends_on = [aws_lb_target_group.forward]
}

############################################
# Optional http to https redirect listener #
############################################
resource "aws_lb_listener" "http-to-https-redirect" {
  count = var.enable_http_to_https_redirect == 1 ? 1 : 0

  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.listener_port
      protocol    = var.listener_protocol
      status_code = "HTTP_301"
    }
  }
}

######################
# DNS CNAME Creation #
######################
resource "aws_route53_record" "cname_alb" {
  count = var.enable_geolocation == 0 && var.cname_subdomain_alb != "" ? 1 : 0

  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.cname_subdomain_alb}.${local.dns_zone}." # eg. something.qa.aws.chownow.com. or something.chownow.com
  type    = var.r53_type
  ttl     = var.r53_ttl_alb
  records = ["${aws_lb.public.dns_name}."]
}

resource "aws_route53_record" "cname_alb_geo" {
  count = var.enable_geolocation == 1 && var.cname_subdomain_alb != "" ? 1 : 0

  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.cname_subdomain_alb}.${local.dns_zone}." # eg. something.qa.aws.chownow.com. or something.chownow.com
  type    = var.r53_type
  ttl     = var.r53_ttl_alb
  records = ["${aws_lb.public.dns_name}."]

  geolocation_routing_policy {
    country = var.cf_geo_country
  }

  set_identifier = var.cf_geo_identifier
}

resource "aws_route53_record" "cname_cloudflare" {
  count = var.cname_subdomain_cloudflare != "" ? 1 : 0

  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.cname_subdomain_cloudflare}.${local.dns_zone}." # eg. something.qa.svpn.chownow.com. or something.chownow.com
  type    = var.r53_type
  ttl     = var.r53_ttl_cloudflare
  records = ["${var.cname_subdomain_cloudflare}.${local.dns_zone}.${var.cloudflare_domain}"] # eg. something.qa.svpn.chownow.com.cdn.cloudflare.net or something.chownow.com.cdn.cloudflare.net

  geolocation_routing_policy {
    country = var.cf_geo_country
  }

  set_identifier = var.cf_geo_identifier
}

resource "aws_route53_record" "cname_cloudflare_gdpr" {
  count = var.cname_subdomain_cloudflare != "" && var.enable_gdpr_cname_cloudflare == 1 ? 1 : 0

  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.cname_subdomain_cloudflare}.${local.dns_zone}." # eg. something.qa.aws.chownow.com. or something.chownow.com
  type    = var.r53_type
  ttl     = var.r53_ttl_cloudflare
  records = ["${var.gdpr_destination}."] # eg. something.qa.aws.chownow.com.cdn.cloudflare.net or something.chownow.com.cdn.cloudflare.net

  geolocation_routing_policy {
    continent = var.gdpr_geo_continent
  }

  set_identifier = var.gdpr_geo_identifier

  depends_on = [aws_route53_record.cname_cloudflare]
}
