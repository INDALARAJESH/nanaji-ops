#######################
# ECS Security Groups #
#######################

resource "aws_security_group" "app" {
  name   = "${local.service}-app-sg-${local.env}"
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.service}-app-sg-${local.env}" }
  )
}

resource "aws_security_group_rule" "app_ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.app.id
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]

}

resource "aws_security_group_rule" "app_egress_allowed_all" {
  type              = "egress"
  security_group_id = aws_security_group.app.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_icmp-self" {
  security_group_id = aws_security_group.app.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  self              = true
}
