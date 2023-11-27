module "channels_rest_api_gateway" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/rest-api-gateway?ref=rest-api-gateway-v2.0.0"
  env       = var.env
  name      = "channels"
  domain    = "${var.env}.chownowapi.com"
  subdomain = "channels"
}
