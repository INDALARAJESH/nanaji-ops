data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_acm_certificate" "star_chownow" {
  domain   = "${var.wildcard_domain_prefix}${local.dns_zone}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "public" {
  name         = "${local.dns_zone}."
  private_zone = false
}

data "aws_ec2_managed_prefix_list" "pritunl_public_ips" {
  filter {
    name   = "prefix-list-name"
    values = ["pritunl-public-ip-list-ops"]
  }
}
