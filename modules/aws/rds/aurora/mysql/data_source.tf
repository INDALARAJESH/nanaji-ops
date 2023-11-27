data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "base" {
  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_subnet_tag_value]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.base.ids)
  id       = each.value
}

data "aws_route53_zone" "dns_zone" {
  vpc_id       = data.aws_vpc.selected.id
  name         = "${var.dns_zone_name}."
  private_zone = var.private_dns_zone
}
