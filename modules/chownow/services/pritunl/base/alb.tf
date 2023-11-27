resource "aws_lb" "pritunl_public" {
  name               = "${var.service}-public-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.pritunl_alb_web_vpn.id,
    aws_security_group.pritunl_alb_web_cloudflare.id,
    aws_security_group.pritunl_internal.id
  ]
  subnets = data.aws_subnets.public.ids

  enable_deletion_protection = true

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-public-${local.env}",
    )
  )
}

resource "aws_lb_listener" "pritunl_http" {
  load_balancer_arn = aws_lb.pritunl_public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-http-${local.env}",
    )
  )
}

resource "aws_lb_listener" "pritunl_https" {
  load_balancer_arn = aws_lb.pritunl_public.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.star_chownow.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_hosts_https.arn
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-https-${local.env}",
    )
  )
}

resource "aws_lb_target_group" "pritunl_hosts_https" {
  name     = "${var.service}-hosts-https-${local.env}"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = data.aws_vpc.pritunl_vpc.id

  health_check {
    protocol            = "HTTPS"
    path                = "/check"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-hosts-https-${local.env}",
    )
  )
}

