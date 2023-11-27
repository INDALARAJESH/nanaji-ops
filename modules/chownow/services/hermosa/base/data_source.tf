data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_canonical_user_id" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_acm_certificate" "star_chownow" {
  domain      = local.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_s3_bucket" "menu_s3" {
  count  = var.enable_bucket_menu
  bucket = local.bucket_menu
}

data "aws_security_group" "ingress_cloudflare" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["allow-cloudflare-ips-${local.vpc_name}"]
  }
}

data "aws_route53_zone" "public" {
  name         = "${local.dns_zone}."
  private_zone = false
}

// Comment out until usefulness is evaluated along with private alb
// data "aws_route53_zone" "private" {
//   name         = "${local.dns_zone}."
//   private_zone = true
// }

data "aws_route53_zone" "chownowcdn_com_pub_zone" {
  name         = "${local.chownowcdn_zone}."
  private_zone = false
}

data "aws_acm_certificate" "chownowcdn" {
  domain      = local.cert_chownowcdn_domain
  statuses    = ["ISSUED"]
  most_recent = true
}
