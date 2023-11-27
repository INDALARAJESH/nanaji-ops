######################
# DB Security Groups #
######################

resource "aws_security_group" "db_proxy" {
  name   = local.name
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_security_group_rule" "db_proxy_ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.db_proxy.id
  from_port         = upper(var.db_engine_family) == "MYSQL" ? 3306 : 5432
  to_port           = upper(var.db_engine_family) == "MYSQL" ? 3306 : 5432
  protocol          = "tcp"
  cidr_blocks       = concat(data.aws_subnet.subnet.*.cidr_block, var.extra_cidr_blocks)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "db_proxy_ingress_tcp_sg_id_allowed" {
  count                    = var.ingress_source_security_group_id != "" ? 1 : 0
  type                     = "ingress"
  security_group_id        = aws_security_group.db_proxy.id
  from_port                = upper(var.db_engine_family) == "MYSQL" ? 3306 : 5432
  to_port                  = upper(var.db_engine_family) == "MYSQL" ? 3306 : 5432
  protocol                 = "tcp"
  source_security_group_id = var.ingress_source_security_group_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "db_egress_allowed_all" {
  type              = "egress"
  security_group_id = aws_security_group.db_proxy.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "db_icmp_self" {
  security_group_id = aws_security_group.db_proxy.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  self              = true
}

