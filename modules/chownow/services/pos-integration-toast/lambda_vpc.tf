# VPC Security Group Configuration
#
# This security group and group rule can be re-used for any lambda requiring execution within a VPC
resource "aws_security_group" "lambda" {
  count = var.lambda_vpc_id != "" ? 1 : 0

  name   = "${local.service}-lambda"
  vpc_id = var.lambda_vpc_id
}

resource "aws_security_group_rule" "lambda_egress_allowed_all" {
  count = var.lambda_vpc_id != "" ? 1 : 0

  type              = "egress"
  security_group_id = aws_security_group.lambda[count.index].id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
