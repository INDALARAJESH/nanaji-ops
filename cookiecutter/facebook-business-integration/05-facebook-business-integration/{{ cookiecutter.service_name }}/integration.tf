module "facebook-business-integration" {
  source               = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/facebook-business-integration?ref=facebook-business-integration-v2.0.1"
  env                  = var.env
  subdomain_name       = "channels"
  domain_name          = "${var.env}.chownowapi.com"
  api_gateway_name     = "channels"
  cors_allow_origins   = "https://admin.${var.env}.chownow.com,https://web.${var.env}.chownow.com:3000,https://app-marketplace.${var.env}.svpn.chownow.com,https://app-order-direct.${var.env}.svpn.chownow.com,https://admin.${var.env}.svpn.chownow.com"
  lambda_image_uri     = "731031120404.dkr.ecr.us-east-1.amazonaws.com/fbe:36ace4d"
}
