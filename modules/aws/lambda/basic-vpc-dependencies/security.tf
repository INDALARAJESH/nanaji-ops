##########################
# Lambda Security Groups #
##########################

resource "aws_security_group" "lambda" {
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

resource "aws_security_group_rule" "lambda_egress_allowed_all" {
  type              = "egress"
  security_group_id = aws_security_group.lambda.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
