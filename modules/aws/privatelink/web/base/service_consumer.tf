####################
# Service Consumer #
####################

# Security group to allow resources on private subnet to access VPC Endpoint
resource "aws_security_group" "vpce" {

  provider = aws.service_consumer

  name   = local.name
  vpc_id = data.aws_vpc.consumer.id
}

resource "aws_security_group_rule" "ingress_tcp_allowed" {

  provider = aws.service_consumer

  cidr_blocks       = concat(local.consumer_private_subnet_cidrs, var.service_consumer_extra_sg_cidr_blocks)
  description       = "Allow communication to ${local.name} endpoint"
  from_port         = var.port
  protocol          = "tcp"
  security_group_id = aws_security_group.vpce.id
  to_port           = var.port
  type              = "ingress"
}

# VPC Endpoint on the consumer side VPC
resource "aws_vpc_endpoint" "privatelink" {

  provider = aws.service_consumer

  private_dns_enabled = true # allows custom domain usage over AWS provided DNS name
  service_name        = aws_vpc_endpoint_service.privatelink.service_name
  security_group_ids  = [aws_security_group.vpce.id]
  subnet_ids          = data.aws_subnet_ids.consumer_private.ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = data.aws_vpc.consumer.id
}
