######################
# DB Security Groups #
######################

resource "aws_security_group" "db" {
  name   = local.name
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.name }
  )
}

resource "aws_security_group_rule" "db_ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.db.id
  from_port         = var.db_tcp_port
  to_port           = var.db_tcp_port
  protocol          = "tcp"
  cidr_blocks       = local.vpc_subnet_cidrs
}

resource "aws_security_group_rule" "db_ingress_tcp_sg_id_allowed" {
  count                    = var.ingress_source_security_group_id != "" ? 1 : 0
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = var.db_tcp_port
  to_port                  = var.db_tcp_port
  protocol                 = "tcp"
  source_security_group_id = var.ingress_source_security_group_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "db_egress_allowed_all" {
  type              = "egress"
  security_group_id = aws_security_group.db.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
