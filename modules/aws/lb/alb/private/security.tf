resource "aws_security_group" "alb_internal" {
  name        = local.alb_name
  description = "Ingress allow for ${local.alb_name}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.alb_name }
  )
}

resource "aws_security_group_rule" "ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_internal.id
  from_port         = var.listener_port
  to_port           = var.listener_port
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]

  depends_on = [aws_security_group.alb_internal]
}
