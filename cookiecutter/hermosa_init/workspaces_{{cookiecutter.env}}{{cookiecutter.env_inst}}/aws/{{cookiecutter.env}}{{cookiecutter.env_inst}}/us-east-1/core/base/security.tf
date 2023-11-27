data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}${var.env_inst}"]
  }
}

resource "aws_security_group" "vpc_cloudflare" {
  name   = "allow-cloudflare-ips-${var.env}${var.env_inst}"
  vpc_id = data.aws_vpc.selected.id

  tags = {
    "Name" = "allow-cloudflare-ips-${var.env}${var.env_inst}"
  }
}

resource "aws_security_group_rule" "cloudflare_ingress_tcp_allowed" {
  count             = length(var.cloudflare_ingress_tcp_allowed)
  type              = "ingress"
  security_group_id = aws_security_group.vpc_cloudflare.id
  from_port         = element(var.cloudflare_ingress_tcp_allowed, count.index)
  to_port           = element(var.cloudflare_ingress_tcp_allowed, count.index)
  protocol          = "tcp"
  cidr_blocks       = var.cloudflare_subnets
}
