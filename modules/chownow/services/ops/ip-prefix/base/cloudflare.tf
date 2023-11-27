#########################
# Cloudflare IPv4 Share #
#########################

resource "aws_ram_resource_share" "cloudflare_public_ipv4" {
  name                      = var.cloudflare_ipv4_name
  allow_external_principals = true

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", var.cloudflare_ipv4_name,
    )
  )
}

resource "aws_ram_principal_association" "cloudflare_public_ipv4" {
  principal          = var.aws_org_arn
  resource_share_arn = aws_ram_resource_share.cloudflare_public_ipv4.arn
}


##########################
# Cloudflare Prefix List #
##########################

resource "aws_ec2_managed_prefix_list" "cloudflare_public_ipv4" {
  name           = var.cloudflare_ipv4_name
  address_family = "IPv4"
  max_entries    = 100


  dynamic "entry" {
    for_each = toset(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks)

    content {
      cidr        = entry.value
      description = "Cloudflare Public IPV4 Address Space"
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", var.cloudflare_ipv4_name,
    )
  )
}



resource "aws_ram_resource_association" "cloudflare_public_ipv4" {
  resource_arn       = aws_ec2_managed_prefix_list.cloudflare_public_ipv4.arn
  resource_share_arn = aws_ram_resource_share.cloudflare_public_ipv4.arn
}
