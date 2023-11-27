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
    values = ["${var.subnet_tag}_base"]
  }
}

data "aws_route53_zone" "public" {
  name = "${local.env}.${var.svpn_subdomain}.${var.domain}."
}
