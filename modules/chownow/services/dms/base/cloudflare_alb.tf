# this file configures:
# - a new ALB for holding delivery provider inbound traffic flows: rules, listeners, target group, etc.
# - a new security group for allowing traffic from CloudFlare source IPs, attached to the ALB
# - the "amazon side" of the "chownow cloudflare integration": an origin record and a public cname to the .cdn.cloudflare.net record

# this file does not configure, but relates to:
# - the cloudflare proxy record ("orange cloud") for dms-providers.{env}.chownowapi.com -> dms-providers-origin.{env}.chownowapi.com
# - a cloudflare allowlist that only lets traffic through from uber DaaS source IPs: "104.36.192.0/21" -- see OPS-3373 comments thread
# - note that new delivery providers will need their source IPs appended to the above allowlist. ask IT for cloudflare access if you need it

resource "aws_lb" "cloudflare" {
  name               = "${var.service}-cloudflare-lb"
  load_balancer_type = "application"
  internal           = false # public LB
  security_groups    = [aws_security_group.allow_https_cloudflare_source_ips.id, data.aws_security_group.ingress_vpn_allow.id, aws_security_group.vpc_local.id]
  subnets            = data.aws_subnets.public_base.ids

  tags = merge({ "Name" = "${var.service}-cloudflare-lb-${local.vpc_name}" }, local.common_tags)
}

# this was ported from the alb public module, "default" SG
resource "aws_security_group" "vpc_local" {
  name_prefix = "${var.service}-local-"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "Service Traffic TCP from this VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  tags = merge({ "Name" = "${var.service}-local-${local.vpc_name}" }, local.common_tags)
}

resource "aws_security_group" "allow_https_cloudflare_source_ips" {
  name_prefix = "${var.service}-cloudflare-"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "HTTPS from CloudFlare"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "104.16.0.0/13", "190.93.240.0/20",
      "104.24.0.0/14", "108.162.192.0/18", "131.0.72.0/22", "141.101.64.0/18", "197.234.240.0/22",
      "162.158.0.0/15", "172.64.0.0/13", "173.245.48.0/20", "188.114.96.0/20", "198.41.128.0/17"
    ]
  }

  egress {
    description = "allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" = "${var.service}-cloudflare-${local.vpc_name}" }, local.common_tags)
}

locals {
  # records for mapping environments to cname slugs because ncp doesnt have a real one
  cloudflare_cname_slugs = {
    "ncp" = "chownowapi.com"
    "qa"  = "qa.chownowapi.com"
    "stg" = "stg.chownowapi.com"
    "uat" = "uat.chownowapi.com"
  }
}

# cname the public record to cloudflare, where a proxy record exists back to -origin
resource "aws_route53_record" "authority_to_cloudflare" {
  zone_id = data.aws_route53_zone.chownowapi.zone_id
  name    = "${var.service}-providers.${local.cloudflare_cname_slugs[local.env]}"
  type    = "CNAME"
  ttl     = 60
  records = ["${var.service}-providers.${local.cloudflare_cname_slugs[local.env]}.cdn.cloudflare.net"]
}

# cname -origin to the backing resource. in this case, the alb's cname
resource "aws_route53_record" "origin_to_endpoint" {
  zone_id = data.aws_route53_zone.chownowapi.zone_id
  name    = "${var.service}-providers-origin.${local.cloudflare_cname_slugs[local.env]}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.cloudflare.dns_name]
}

resource "aws_lb_target_group" "cloudflare_https" {
  name        = "${var.service}-cloudflare-backend"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    interval            = 6
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }

  tags = merge({ "Name" = "${var.service}-cloudflare-backend-${local.vpc_name}" }, local.common_tags)
}

# if you need to trigger a replacement of any of the LB resources in this file, you'll have to comment out the bottom two below this comment
# otherwise terraform can't handle walking the resource graph with the replacement, it tries to delete things without cleaning them up first and fails
resource "aws_lb_listener" "cloudflare_deliveryprovider_traffic" {
  load_balancer_arn = aws_lb.cloudflare.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.star_chownow.arn

  # for unmatched traffic return an http 421 "misdirected request"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "421"
    }
  }
}

resource "aws_lb_listener_rule" "cloudflare_deliveryprovider_traffic" {
  listener_arn = aws_lb_listener.cloudflare_deliveryprovider_traffic.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloudflare_https.arn
  }
  condition {
    path_pattern {
      values = ["/webhooks/*"]
    }
  }
}
