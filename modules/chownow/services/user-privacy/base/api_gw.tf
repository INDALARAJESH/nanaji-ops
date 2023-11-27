module "rest_api_gateway" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/gateway?ref=rest-api-gateway-v2.0.0"

  env  = var.env
  name = local.app_name

}
