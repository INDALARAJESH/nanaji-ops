resource "aws_security_group" "vm" {
  name        = local.server_group
  description = "security group for ${local.server_group} instances"
  vpc_id      = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.server_group }
  )
}

resource "aws_security_group_rule" "ingress_tcp_allowed" {
  count = length(var.ingress_tcp_allowed)

  type              = "ingress"
  security_group_id = aws_security_group.vm.id
  from_port         = element(var.ingress_tcp_allowed, count.index)
  to_port           = element(var.ingress_tcp_allowed, count.index)
  protocol          = "tcp"
  cidr_blocks       = concat([data.aws_vpc.selected.cidr_block], var.ingress_cidr_blocks)

  depends_on = [aws_security_group.vm]
}

resource "aws_security_group_rule" "egress_allow_all" {
  count = var.enable_egress_allow_all == 1 ? 1 : 0

  type              = "egress"
  security_group_id = aws_security_group.vm.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [aws_security_group.vm]
}
