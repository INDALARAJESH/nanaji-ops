resource "aws_vpc" "mod" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  enable_classiclink   = var.enable_classiclink

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.vpc_name_prefix}-${local.env}" }
  )
}

output "vpc_id" {
  value = aws_vpc.mod.id
}


#############################
# AWS Service VPC Endpoints #
#############################

resource "aws_security_group" "aws_service_vpce" {
  count = var.enable_vpce_aws == 1 ? 1 : 0

  name        = "aws-service-vpce-${local.vpc_name}"
  description = "allows ${local.vpc_name} VPC CIDR block access to AWS Service VPC endpoint"
  vpc_id      = aws_vpc.mod.id

  ingress {
    description = "TLS from AWS Service VPC Endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.mod.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "aws-service-vpce-${local.vpc_name}" }
  )
}


resource "aws_vpc_endpoint" "s3" {
  count = var.enable_vpce_aws == 1 ? 1 : 0

  vpc_id       = aws_vpc.mod.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "aws-s3-vpce-${local.vpc_name}" }
  )
}

resource "aws_vpc_endpoint" "ecr" {
  count = var.enable_vpce_aws == 1 ? 1 : 0

  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.aws_service_vpce[0].id]
  vpc_id              = aws_vpc.mod.id
  subnet_ids          = aws_subnet.private.*.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "aws-ecr-vpce-${local.vpc_name}" }
  )
}




#########################
# Datadog VPC Endpoints #
#########################

# https://docs.datadoghq.com/agent/guide/private-link/?tab=useast1

resource "aws_security_group" "datadog_vpce" {
  count = var.enable_vpce_datadog == 1 ? 1 : 0

  name        = "datadog-vpce-${local.vpc_name}"
  description = "allows ${local.vpc_name} VPC CIDR block access to datadog VPC endpoint"
  vpc_id      = aws_vpc.mod.id

  ingress {
    description = "TLS from Datadog VPC Endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.mod.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"    = "datadog-vpce-${local.vpc_name}",
      "Service" = "datadog",
    }
  )
}


resource "aws_vpc_endpoint" "datadog_vpce" {
  for_each = local.datadog_endpoints

  private_dns_enabled = true
  service_name        = each.value.service_name
  security_group_ids  = [aws_security_group.datadog_vpce[0].id]
  subnet_ids          = aws_subnet.private.*.id
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.mod.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"    = each.value.name,
      "Service" = "datadog",
    }
  )
}
