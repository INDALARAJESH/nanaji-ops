resource "aws_ram_resource_share" "pritunl_public_ip_share" {
  name                      = "${var.service}-public-ip-share-${local.env}"
  allow_external_principals = true

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-public-ip-share-${local.env}",
    )
  )
}

resource "aws_ram_resource_association" "pritunl_public_ip_share_association" {
  resource_arn       = aws_ec2_managed_prefix_list.pritunl_public_ip_list.arn
  resource_share_arn = aws_ram_resource_share.pritunl_public_ip_share.arn
}


resource "aws_ram_principal_association" "chownow_pritunl_public_ip_share" {
  principal          = data.aws_organizations_organization.chownow.arn
  resource_share_arn = aws_ram_resource_share.pritunl_public_ip_share.arn
}
