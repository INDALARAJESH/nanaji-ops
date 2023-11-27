############
# Provider #
############

data "aws_vpc" "provider" {

  provider = aws.service_provider

  filter {
    name   = "tag:Name"
    values = [var.service_provider_vpc_name]
  }
}

data "aws_subnet_ids" "provider_privatelink" {

  provider = aws.service_provider

  vpc_id = data.aws_vpc.provider.id

  filter {
    name   = "tag:NetworkZone"
    values = var.provider_vpc_private_subnet_tag_key
  }
}

data "aws_route53_zone" "provider_public" {

  provider = aws.service_provider

  name = "${local.dns_zone}."
}

data "aws_lb" "service_provider_alb" {
  provider = aws.service_provider

  name = var.service_provider_alb_name
}


############
# Consumer #
############

data "aws_vpc" "consumer" {

  provider = aws.service_consumer

  filter {
    name   = "tag:Name"
    values = [var.service_consumer_vpc_name]
  }
}

data "aws_subnet_ids" "consumer_private" {

  provider = aws.service_consumer

  vpc_id = data.aws_vpc.consumer.id

  filter {
    name   = "tag:NetworkZone"
    values = var.consumer_vpc_private_subnet_tag_key
  }
}

data "aws_subnet" "consumer_private" {

  provider = aws.service_consumer

  for_each = data.aws_subnet_ids.consumer_private.ids
  id       = each.value
}
