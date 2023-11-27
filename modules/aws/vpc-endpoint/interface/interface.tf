resource "aws_vpc_endpoint" "interface" {
  vpc_endpoint_type = "Interface"

  vpc_id       = data.aws_vpc.selected.id
  service_name = local.interface_service_name

  private_dns_enabled = data.aws_vpc.selected.enable_dns_support

  #  For Security group, select the security group to associate with the VPC endpoint network interfaces.
  #  The security group you choose must be set to allow TCP Port 443 inbound HTTPS traffic from either
  #  an IP range in your VPC or another security group in your VPC.
  security_group_ids = [
    aws_security_group.interface_vpc_endpoint.id,
  ]

  subnet_ids = data.aws_subnet_ids.private.ids

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = format("%s-%s-%s", data.aws_vpc.selected.tags.Name, var.service_name, var.name),
    }
  )
}
