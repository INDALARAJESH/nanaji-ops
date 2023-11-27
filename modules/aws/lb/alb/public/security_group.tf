resource "aws_security_group" "default" {
  name        = local.security_group_name
  description = "security group to allow incoming connections from VPC to service ${var.service}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.security_group_name }
  )
}

resource "aws_security_group_rule" "ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.default.id
  from_port         = var.listener_port
  to_port           = var.listener_port
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
}

resource "aws_security_group_rule" "egress_allow_all" {
  type              = "egress"
  security_group_id = aws_security_group.default.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
