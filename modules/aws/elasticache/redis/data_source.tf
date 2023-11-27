data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnet_ids" "private_base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_value]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "private" {
  count        = var.private_dns_zone ? 1 : 0
  vpc_id       = data.aws_vpc.selected.id
  name         = "${local.dns_zone}."
  private_zone = true
}

data "aws_route53_zone" "public" {
  count = var.private_dns_zone ? 0 : 1
  name  = "${local.dns_zone}."
}

data "aws_secretsmanager_secret" "redis_auth_token" {
  count = local.create_redis_authtoken == 0 ? 1 : 0
  name  = "${local.env}/${var.service}/redis_auth_token"
}

data "aws_secretsmanager_secret_version" "redis_auth_token" {
  count = local.create_redis_authtoken == 0 ? 1 : 0

  secret_id     = data.aws_secretsmanager_secret.redis_auth_token[0].id
  version_stage = "AWSCURRENT"
}
