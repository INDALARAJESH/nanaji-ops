module "rest_api_gateway_openapi_private_deployment" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/deployment?ref=aws-api-gateway-rest-deployment-v2.0.0"

  env      = var.env
  env_inst = var.env_inst

  api_id              = module.rest_api_gateway_openapi_private.api_id
  create_api_key      = var.create_api_key
  access_log_settings = local.access_log_settings

  redeployment_trigger = [
    module.rest_api_gateway_openapi_private.openapi_spec_checksum,
    module.rest_api_gateway_openapi_private.api_gw_resource_policy_checksum
  ]

  extra_tags = local.extra_tags
}
