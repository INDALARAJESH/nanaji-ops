############
# Gateways #
############
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mod.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${var.vpc_name_prefix}-igw-${local.env}"
    }
  )
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.public.0.id

  depends_on = [aws_subnet.public]

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${var.vpc_name_prefix}-nat-gw-${local.env}"
    }
  )
}

resource "aws_eip" "nat_gw" {
  vpc = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${var.vpc_name_prefix}-nat-gw-${local.env}"
    }
  )
}

####################
# Private Networks #
####################

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.mod.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"        = "${var.vpc_name_prefix}-private${count.index}-${local.env}",
      "NetworkZone" = "private_base",
      "NetworkType" = "private",
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mod.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = "${var.vpc_name_prefix}-rt-private-${local.env}"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_to_nat" {
  # Allow all outbound traffic through the NAT
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id

  timeouts {
    create = "5m"
  }
}

###################
# Public Networks #
###################

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.mod.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name"        = "${var.vpc_name_prefix}-public${count.index}-${local.env}",
      "NetworkZone" = "public_base",
      "NetworkType" = "public"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mod.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.vpc_name_prefix}-rt-public-${local.env}" }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# conditional based on length of input cidr blocks
# todo: we probably want to keep track of the AZ and output it as a complex type
# as-is, any downstream consumers who need the AZ for a subnet need to look it up, which is not ideal
output "private_subnet_ids" { value = length(var.private_subnets) > 0 ? aws_subnet.private.*.id : null }
output "public_subnet_ids" { value = length(var.public_subnets) > 0 ? aws_subnet.public.*.id : null }

# always exist, no conditional needed
output "private_gateway_id" { value = aws_nat_gateway.ngw.id }
output "private_rtb_id" { value = length(var.private_subnets) > 0 ? aws_route_table.private.id : null }
output "public_gateway_id" { value = aws_internet_gateway.igw.id }
output "public_rtb_id" { value = length(var.public_subnets) > 0 ? aws_route_table.public.id : null }


