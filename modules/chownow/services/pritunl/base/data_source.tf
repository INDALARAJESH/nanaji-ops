data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_organizations_organization" "chownow" {}

### Pritunl VPN VPC

data "aws_vpc" "pritunl_vpc" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

### ACM Certificate

data "aws_acm_certificate" "star_chownow" {
  domain      = "${var.wildcard_domain_prefix}${local.dns_zone}"
  statuses    = ["ISSUED"]
  most_recent = true
}

### Public DNS Zone - svpn.chownow.com

data "aws_route53_zone" "public" {
  name         = local.dns_zone
  private_zone = false
}

### Public VPC Subnets

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.pritunl_vpc.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["public_base"]
  }
}

### Cloudflare IPs Prefix List

data "aws_ec2_managed_prefix_list" "cloudflare_ips" {
  filter {
    name   = "prefix-list-name"
    values = ["cloudflare-public-ipv4"]
  }
}
