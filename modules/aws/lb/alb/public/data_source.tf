data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    NetworkZone = var.vpc_public_subnet_tag_key
  }
}

data "aws_route53_zone" "public" {
  name         = "${local.dns_zone}."
  private_zone = false
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}
