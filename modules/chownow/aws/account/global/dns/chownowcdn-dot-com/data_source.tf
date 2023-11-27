data "aws_route53_zone" "chownowcdn_dot_com" {
  name         = "${var.domain_chownowcdn}."
  private_zone = false
}

data "aws_route53_zone" "delegate_uatload_chownowcdn_dot_com" {
  provider = aws.delegate_uat
  name     = "uatload.${var.domain_chownowcdn}"
}

data "aws_route53_zone" "delegate_uat_chownowcdn_dot_com" {
  provider = aws.delegate_uat
  name     = "uat.${var.domain_chownowcdn}"
}

data "aws_route53_zone" "delegate_stg_chownowcdn_dot_com" {
  provider = aws.delegate_stg
  name     = "stg.${var.domain_chownowcdn}"
}

data "aws_route53_zone" "delegate_dev_chownowcdn_dot_com" {
  provider = aws.delegate_dev
  name     = "dev.${var.domain_chownowcdn}"
}
data "aws_route53_zone" "delegate_qa_chownowcdn_dot_com" {
  provider = aws.delegate_qa
  name     = "qa.${var.domain_chownowcdn}"
}
