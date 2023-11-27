resource "aws_vpc_endpoint" "gateway" {
  vpc_endpoint_type = "Gateway"

  vpc_id       = data.aws_vpc.selected.id
  service_name = local.gateway_service_name

  policy = local.endpoint_policy

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${data.aws_vpc.selected.tags.Name}-${var.service_name}" }
  )
}

resource "aws_vpc_endpoint_route_table_association" "gateway" {
  count = length(local.route_table_ids)

  route_table_id  = local.route_table_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.gateway.id
}
