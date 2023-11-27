data "aws_vpc" "selected" {


  filter {
    name   = "tag:Name"
    values = [var.service_provider_vpc_name]
  }
}

data "aws_subnets" "provider_privatelink" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["privatelink"]
  }
}

data "aws_route53_zone" "provider_public" {


  name = "${local.dns_zone}."
}

data "aws_lb" "service_provider_alb" {

  name = var.service_provider_alb_name
}
