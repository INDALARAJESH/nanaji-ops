#############################
# AWS Service VPC Endpoints #
#############################

resource "aws_security_group" "aws_service_vpce" {
  count = var.enable_vpce_aws == 1 ? 1 : 0

  name        = "aws-service-vpce-${var.vpc_name}"
  description = "allows ${var.vpc_name} VPC CIDR block access to AWS Service VPC endpoint"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description      = "TLS from AWS Service VPC Endpoint"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
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
    { "Name" = "aws-service-vpce-${var.vpc_name}" }
  )
}


resource "aws_vpc_endpoint" "s3" {
  count = var.enable_vpce_aws == 1 ? 1 : 0

  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "aws-s3-vpce-${var.vpc_name}" }
  )
}

resource "aws_vpc_endpoint" "ecr" {
  count = var.enable_vpce_aws == 1 ? 1 : 0

  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [aws_security_group.aws_service_vpce[0].id]
  vpc_id              = data.aws_vpc.selected.id
  subnet_ids          = data.aws_subnet_ids.base.ids

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "aws-ecr-vpce-${var.vpc_name}" }
  )
}


#########################
# Datadog VPC Endpoints #
#########################

# https://docs.datadoghq.com/agent/guide/private-link/?tab=useast1

resource "aws_security_group" "datadog_vpce" {
  count = var.enable_vpce_datadog == 1 ? 1 : 0

  name        = "datadog-vpce-${var.vpc_name}"
  description = "allows ${var.vpc_name} VPC CIDR block access to datadog VPC endpoint"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description      = "TLS from Datadog VPC Endpoint"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
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
    { "Name" = "datadog-vpce-${var.vpc_name}"
"Service" = "datadog" }
  )
}


resource "aws_vpc_endpoint" "datadog_vpce" {
  for_each = local.datadog_endpoints

  private_dns_enabled = true
  service_name        = each.value.service_name
  security_group_ids = [aws_security_group.datadog_vpce[0].id]
  subnet_ids          = data.aws_subnet_ids.base.ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = each.value.name
"Service" = "datadog" }
  )
}
