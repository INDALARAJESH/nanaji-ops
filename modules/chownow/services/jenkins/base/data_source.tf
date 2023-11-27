data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_security_group" "internal_allow" {
  filter {
    name   = "tag:Name"
    values = ["internal-${var.env}"]
  }
}

data "aws_security_group" "alb_allow" {
  filter {
    name   = "tag:Name"
    values = ["ops-alb allows"]
  }
}

data "aws_route53_zone" "svpn" {
  name         = var.svpn_dns_zone_name
  private_zone = false
}

data "aws_instance" "jenkins_ec2" {
  filter {
    name   = "tag:Name"
    values = ["${var.jenkins_ec2_name}0-${var.env}"]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.env]
  }
}

# dunno if needed. this was used in the original ec2 module
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

data "aws_lb" "alb" {
  name = var.alb_name
}

data "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = 443
}

data "aws_canonical_user_id" "current" {}
