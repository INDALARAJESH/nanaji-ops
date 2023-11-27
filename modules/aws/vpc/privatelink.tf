###############
# PrivateLink #
###############

resource "aws_subnet" "privatelink" {
  count             = length(var.privatelink_subnets)
  vpc_id            = aws_vpc.mod.id
  cidr_block        = var.privatelink_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"        = "${var.vpc_name_prefix}-privatelink${count.index}-${local.env}",
      "NetworkZone" = "privatelink",
      "NetworkType" = "privatelink",
    }
  )
}


resource "aws_route_table_association" "privatelink" {
  count          = length(var.privatelink_subnets)
  subnet_id      = element(aws_subnet.privatelink.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
