data "aws_route53_zone" "chownow_dot_com" {
  name         = "${var.domain}."
  private_zone = false
}

data "aws_route53_zone" "delegate_uatload_chownow_dot_com" {
  provider = aws.delegate_uat
  name     = "uatload.svpn.${var.domain}"
}

data "aws_route53_zone" "delegate_uat_chownow_dot_com" {
  provider = aws.delegate_uat
  name     = "uat.svpn.${var.domain}"
}

data "aws_route53_zone" "delegate_stg_chownow_dot_com" {
  provider = aws.delegate_stg
  name     = "stg.svpn.${var.domain}"
}

data "aws_route53_zone" "delegate_sandbox_chownow_dot_com" {
  provider = aws.delegate_sandbox
  name     = "sandbox.svpn.${var.domain}"
}
