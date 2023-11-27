resource "aws_security_group" "custom" {
  name        = local.security_group_name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.security_group_name }
  )
}

resource "aws_security_group_rule" "ingress_tcp_allowed" {
  count = length(var.ingress_tcp_allowed)

  type              = "ingress"
  security_group_id = aws_security_group.custom.id
  from_port         = element(var.ingress_tcp_allowed, count.index)
  to_port           = element(var.ingress_tcp_allowed, count.index)
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks

  depends_on = [aws_security_group.custom]
}

resource "aws_security_group_rule" "ingress_udp_allowed" {
  count = length(var.ingress_udp_allowed)

  type              = "ingress"
  security_group_id = aws_security_group.custom.id
  from_port         = element(var.ingress_udp_allowed, count.index)
  to_port           = element(var.ingress_udp_allowed, count.index)
  protocol          = "udp"
  cidr_blocks       = var.cidr_blocks

  depends_on = [aws_security_group.custom]
}

resource "aws_security_group_rule" "ingress_custom_allowed" {
  count = var.ingress_custom_self ? 0 : length(var.ingress_custom_allowed)

  type              = "ingress"
  security_group_id = aws_security_group.custom.id
  from_port         = element(var.ingress_custom_allowed, count.index)
  to_port           = element(var.ingress_custom_allowed, count.index)
  protocol          = var.ingress_custom_protocol
  cidr_blocks       = var.cidr_blocks

  depends_on = [aws_security_group.custom]
}

resource "aws_security_group_rule" "ingress_custom_self" {
  count = var.ingress_custom_self ? length(var.ingress_custom_allowed) : 0

  type              = "ingress"
  security_group_id = aws_security_group.custom.id
  from_port         = element(var.ingress_custom_allowed, count.index)
  to_port           = element(var.ingress_custom_allowed, count.index)
  protocol          = var.ingress_custom_protocol
  self              = var.ingress_custom_self

  depends_on = [aws_security_group.custom]
}

resource "aws_security_group_rule" "egress_allow_all" {
  count = var.enable_egress_allow_all == 1 ? 1 : 0

  type              = "egress"
  security_group_id = aws_security_group.custom.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [aws_security_group.custom]
}
