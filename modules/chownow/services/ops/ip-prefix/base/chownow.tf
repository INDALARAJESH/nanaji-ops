######################
# ChowNow IPv4 Share #
######################

resource "aws_ram_resource_share" "chownow_public_ipv4" {
  name                      = local.chownow_ipv4_vpn_name
  allow_external_principals = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", var.chownow_ipv4_share_name,
    )
  )
}

resource "aws_ram_principal_association" "chownow_public_ipv4" {
  principal          = var.aws_org_arn
  resource_share_arn = aws_ram_resource_share.chownow_public_ipv4.arn
}


###########################
# ChowNow VPN Prefix List #
###########################

resource "aws_ec2_managed_prefix_list" "chownow_public_ipv4_vpn" {
  name           = local.chownow_ipv4_vpn_name
  address_family = "IPv4"
  max_entries    = 100


  dynamic "entry" {
    for_each = toset(var.chownow_ipv4_vpn_ips)

    content {
      cidr        = entry.value
      description = "ChowNow Public IPV4 VPN Address Space"
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.chownow_ipv4_vpn_name,
    )
  )
}

resource "aws_ram_resource_association" "chownow_public_ipv4_vpn" {
  resource_arn       = aws_ec2_managed_prefix_list.chownow_public_ipv4_vpn.arn
  resource_share_arn = aws_ram_resource_share.chownow_public_ipv4.arn
}



####################################
# ChowNow NAT Gateway Prefix Lists #
####################################

resource "aws_ec2_managed_prefix_list" "chownow_public_ipv4_natgw" {

  for_each = var.nat_gw_ips

  name           = each.value.name
  address_family = "IPv4"
  max_entries    = 100


  dynamic "entry" {
    for_each = toset(each.value.ips)

    content {
      cidr        = entry.value
      description = each.value.description
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", each.value.name,
      "Environment", each.value.tag_environment,
    )
  )
}


resource "aws_ram_resource_association" "chownow_public_ipv4_natgw" {
  for_each           = var.nat_gw_ips
  resource_arn       = aws_ec2_managed_prefix_list.chownow_public_ipv4_natgw[each.key].arn
  resource_share_arn = aws_ram_resource_share.chownow_public_ipv4.arn
}
