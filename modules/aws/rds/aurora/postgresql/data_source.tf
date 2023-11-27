data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnet_ids" "base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_subnet_tag_value]
  }
}

data "aws_subnet" "subnet" {
  for_each = data.aws_subnet_ids.base.ids
  id       = each.value
}

data "aws_route53_zone" "private" {
  count        = local.is_private
  vpc_id       = data.aws_vpc.selected.id
  name         = format("%s.aws.%s.", local.env, var.domain)
  private_zone = true
}

# Production Zone
data "aws_route53_zone" "public" {
  count        = local.is_private == 0 ? 1 : 0
  name         = var.domain
  private_zone = false
}
