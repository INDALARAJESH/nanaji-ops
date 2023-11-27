###############
# Private ALB #
###############
resource "aws_lb" "private" {
  name               = local.alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = concat([aws_security_group.alb_internal.id], var.security_group_ids)
  subnets            = data.aws_subnet_ids.private.ids

  access_logs {
    bucket  = local.alb_log_bucket
    enabled = var.access_logs_enabled
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"        = local.alb_name
      "NetworkType" = "private"
    }
  )
}

###############################
# Fixed-Response ALB Listener #
###############################
resource "aws_alb_listener" "fixed-response" {
  count = var.listener_da_type == "fixed-response" ? 1 : 0

  load_balancer_arn = aws_lb.private.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = var.listener_da_type

    fixed_response {
      content_type = var.listener_da_fixed_content_type
      status_code  = var.listener_da_fixed_status_code
    }
  }
}

###########################
# Forwarding ALB Listener #
###########################

resource "aws_lb_target_group" "forward" {
  count = var.listener_da_type == "forward" ? 1 : 0

  name     = "${local.alb_name}-${lower(local.tg_port)}"
  port     = local.tg_port
  protocol = var.listener_protocol
  vpc_id   = var.vpc_id

  health_check {
    path     = var.health_check_target
    protocol = var.listener_protocol
    matcher  = var.health_check_matcher
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${aws_lb.private.name}-${lower(local.tg_port)}",
    }
  )
}

resource "aws_alb_listener" "forward" {
  count = var.listener_da_type == "forward" ? 1 : 0

  load_balancer_arn = aws_lb.private.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = var.listener_da_type
    target_group_arn = aws_lb_target_group.forward[count.index].arn
  }

  depends_on = [aws_lb_target_group.forward]
}

############################################
# Optional http to https redirect listener #
############################################
resource "aws_lb_listener" "http-to-https-redirect" {
  count = var.enable_http_to_https_redirect == 1 ? 1 : 0

  load_balancer_arn = aws_lb.private.arn
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
  count = var.cname_subdomain_alb == "" ? 0 : 1

  zone_id = data.aws_route53_zone.private.zone_id
  name    = "${var.cname_subdomain_alb}.${local.dns_zone}." # eg. something.qa.aws.chownow.com. or something.chownow.com
  type    = var.r53_type
  ttl     = var.r53_ttl
  records = ["${aws_lb.private.dns_name}."]
}
