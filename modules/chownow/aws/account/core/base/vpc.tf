############
# Main VPC #
############

module "vpc_main" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc?ref=aws-vpc-v2.1.6"

  count = var.enable_vpc_main

  azs                   = tolist(data.aws_availability_zones.available.names)
  cidr_block            = var.cidr_block_main
  enable_vpce_aws       = var.enable_vpce_aws
  enable_vpce_datadog   = var.enable_vpce_datadog
  env                   = var.env
  env_inst              = var.env_inst
  extra_allowed_subnets = var.extra_allowed_subnets_main
  private_subnets       = length(var.private_subnets_main) > 0 ? var.private_subnets_main : local.private_subnets_main
  public_subnets        = length(var.public_subnets_main) > 0 ? var.public_subnets_main : local.public_subnets_main
  vpc_name_prefix       = var.vpc_name_prefix_main

  privatelink_subnets = var.privatelink_subnets_main

}

###########################
# Non-Cardholder Data VPC #
###########################

module "vpc_nc" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc?ref=aws-vpc-v2.1.6"

  count = var.enable_vpc_nc == 1 && var.cidr_block_nc != "" ? 1 : 0

  azs                   = tolist(data.aws_availability_zones.available.names)
  cidr_block            = var.cidr_block_nc
  enable_vpce_datadog   = var.enable_vpce_datadog
  env                   = var.env
  env_inst              = var.env_inst
  extra_allowed_subnets = var.extra_allowed_subnets_nc
  private_subnets       = length(var.private_subnets_nc) > 0 ? var.private_subnets_nc : local.private_subnets_nc
  public_subnets        = length(var.public_subnets_nc) > 0 ? var.public_subnets_nc : local.public_subnets_nc
  vpc_name_prefix       = var.vpc_name_prefix_nc

  privatelink_subnets = var.privatelink_subnets_nc

}

###########################
#    Pritunl VPN VPC      #
###########################

module "vpc_pritunl" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc?ref=aws-vpc-v2.1.6"

  count = var.enable_vpc_pritunl == 1 && var.cidr_block_pritunl != "" ? 1 : 0

  azs                   = tolist(data.aws_availability_zones.available.names)
  cidr_block            = var.cidr_block_pritunl
  enable_vpce_datadog   = var.enable_vpce_datadog
  env                   = var.env
  env_inst              = var.env_inst
  extra_allowed_subnets = var.extra_allowed_subnets_pritunl
  private_subnets       = length(var.private_subnets_pritunl) > 0 ? var.private_subnets_pritunl : local.private_subnets_pritunl
  public_subnets        = length(var.public_subnets_pritunl) > 0 ? var.public_subnets_pritunl : local.public_subnets_pritunl
  vpc_name_prefix       = var.vpc_name_prefix_pritunl

  privatelink_subnets = var.privatelink_subnets_pritunl

}

############
# Env VPC #
############
resource "aws_vpc" "env" {
  count                = var.enable_vpc_env
  cidr_block           = var.cidr_block_env
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.env
    }
  )

  enable_classiclink = false
}

resource "aws_internet_gateway" "env" {
  count = var.enable_vpc_env

  vpc_id = aws_vpc.env[count.index].id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.env
    }
  )
}

resource "aws_route_table" "public" {
  count = var.enable_vpc_env

  vpc_id = aws_vpc.env[count.index].id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${local.env}-public"
    }
  )
}

resource "aws_route_table" "private" {
  count = var.enable_vpc_env == 1 && !var.extended_subnet_naming ? 1 : 0

  vpc_id = aws_vpc.env[count.index].id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${local.env}-private"
    }
  )
}

resource "aws_route_table" "private_extended" {
  count = var.enable_vpc_env == 1 && var.extended_subnet_naming ? length(var.private_subnets_env) : 0

  vpc_id = aws_vpc.env[0].id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = format("${local.env}-private-%s", element(var.availability_zones, count.index))
    }
  )
}

resource "aws_route" "internet_gateway" {
  count = var.enable_vpc_env

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.env[0].id
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.env[0].id
  cidr_block        = var.private_subnets_env[count.index]
  availability_zone = var.availability_zones[count.index]
  count             = var.enable_vpc_env == 1 && !var.extended_subnet_naming ? length(var.private_subnets_env) : 0

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"        = "${local.env}${count.index}-private"
      "NetworkZone" = "private_base"
      "NetworkType" = "private"
    }
  )
}

resource "aws_subnet" "private_extended" {
  vpc_id            = aws_vpc.env[0].id
  cidr_block        = var.private_subnets_env[count.index]
  availability_zone = var.availability_zones[count.index]
  count             = var.enable_vpc_env == 1 && var.extended_subnet_naming ? length(var.private_subnets_env) : 0

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"        = format("${local.env}-private-%s", element(var.availability_zones, count.index))
      "NetworkZone" = "private_base"
      "NetworkType" = "private"
    }
  )
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.env[0].id
  cidr_block              = var.public_subnets_env[count.index]
  availability_zone       = var.availability_zones[count.index]
  count                   = var.enable_vpc_env == 1 && !var.extended_subnet_naming ? length(var.public_subnets_env) : 0
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"        = "${local.env}${count.index}-public"
      "NetworkZone" = "public_base"
      "NetworkType" = "public"
    }
  )
}

resource "aws_subnet" "public_extended" {
  vpc_id                  = aws_vpc.env[0].id
  cidr_block              = var.public_subnets_env[count.index]
  availability_zone       = var.availability_zones[count.index]
  count                   = var.enable_vpc_env == 1 && var.extended_subnet_naming ? length(var.public_subnets_env) : 0
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"        = format("${local.env}-public-%s", element(var.availability_zones, count.index))
      "NetworkZone" = "public_base"
      "NetworkType" = "public"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = var.enable_vpc_env == 1 && !var.extended_subnet_naming ? length(var.private_subnets_env) : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private[0].id
}

resource "aws_route_table_association" "public" {
  count          = var.enable_vpc_env == 1 && !var.extended_subnet_naming ? length(var.public_subnets_env) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private_extended" {
  count          = var.enable_vpc_env == 1 && var.extended_subnet_naming ? length(var.private_subnets_env) : 0
  subnet_id      = element(aws_subnet.private_extended.*.id, count.index)
  route_table_id = aws_route_table.private_extended[count.index].id
}

resource "aws_route_table_association" "public_extended" {
  count          = var.enable_vpc_env == 1 && var.extended_subnet_naming ? length(var.public_subnets_env) : 0
  subnet_id      = element(aws_subnet.public_extended.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}
