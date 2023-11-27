resource "aws_security_group" "jenkins_replica" {
  name   = "jenkins-replica-${var.env}"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [data.aws_security_group.internal_allow.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "jenkins-replica-${var.env}",
    )
  )
}

resource "aws_eip" "jenkins_eip" {
  instance = data.aws_instance.jenkins_ec2.id
  vpc      = true
  tags     = local.common_tags
}

module "r53_jenkins_public" {
  # r53 module
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"
  records = ["${data.aws_lb.alb.dns_name}."]
  zone_id = data.aws_route53_zone.svpn.id
  type    = "CNAME"
  ttl     = "900"
  name    = "jenkins.${var.svpn_dns_zone_name}"
}

resource "aws_alb_listener_rule" "jenkinss-listener-rule" {
  listener_arn = data.aws_lb_listener.alb_https_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.jankyns-target-group.id
  }

  condition {
    host_header {
      values = ["jenkins.${var.svpn_dns_zone_name}"]
    }
  }
}

module "r53_jankyns_public" {
  # r53 module
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.0"
  records = ["${data.aws_lb.alb.dns_name}."]
  zone_id = data.aws_route53_zone.svpn.id
  type    = "CNAME"
  ttl     = "900"
  name    = "jenkins2.${var.svpn_dns_zone_name}"
}

resource "aws_alb_listener_rule" "jenkins2-redirect" {
  listener_arn = data.aws_lb_listener.alb_https_listener.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "jenkins.${var.svpn_dns_zone_name}"
    }
  }

  condition {
    host_header {
      values = ["jenkins2.${var.svpn_dns_zone_name}"]
    }
  }
}

# github webhook -> ops-alb -> jenkins
# replaces previous: github webhook -> webhook-elb -> webhookproxy box -> jenkins
# gonna use the ops-alb-ops ALB set up to do stuff for ops (see grafana/influx)

resource "aws_route53_record" "webhook-alias" {
  zone_id = data.aws_route53_zone.svpn.zone_id
  name    = "webhook.ops.svpn.chownow.com"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_alb_listener_rule" "jankyns-listener-rule" {
  listener_arn = data.aws_lb_listener.alb_https_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.jankyns-target-group.id
  }

  condition {
    host_header {
      values = ["webhook.${var.svpn_dns_zone_name}"]
    }
  }

  tags = local.common_tags
}

resource "aws_alb_target_group" "jankyns-target-group" {
  name     = "jankyns-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    interval = 60
    path     = "/login"
  }
  tags = merge(
    local.common_tags,
    map(
      "Name", "jankyns-target-group",
    )
  )
}

resource "aws_alb_target_group_attachment" "jankyns-target-group-attachment" {
  target_group_arn = aws_alb_target_group.jankyns-target-group.arn
  target_id        = data.aws_instance.jenkins_ec2.id
  port             = 8080
}

# Allow access from github (api.github.com/meta)
resource "aws_security_group_rule" "github-webhookhttps" {
  type              = "ingress"
  description       = "github access to 443"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = var.github_ip_ranges
  security_group_id = data.aws_security_group.alb_allow.id
}
