data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_key]
  }
}

data "aws_route53_zone" "private" {
  name         = "${local.dns_zone}."
  vpc_id       = var.vpc_id
  private_zone = true
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}
