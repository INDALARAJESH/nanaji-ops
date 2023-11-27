/*
  App Module
*/
module "rest_api_gateway_openapi_private" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/gateway-private-openapi?ref=aws-api-gateway-rest-gateway-private-openapi-v2.0.0"

  name       = format("%s-private", local.app_name)
  env        = var.env
  env_inst   = var.env_inst
  extra_tags = local.extra_tags

  # these are used for resource policy for this private api gw
  source_vpc_endpoint_ids = [
    data.aws_vpc_endpoint.api_gw_private_vpce_main.id,
    data.aws_vpc_endpoint.api_gw_private.id
  ]

  # This is used for the VPC Endpoint interface to be associated with the API GW
  vpc_endpoint_ids = [data.aws_vpc_endpoint.api_gw_private.id]

  # this apigw-spec.json is already jsonencoded()
  openapi_spec_json = templatefile(format("%s/templates/apigw.all.json", path.module), {
    api-lambda-invoke-arn = coalesce(
      module.lambda_api.lambda_function_invoke_arn_alias_newest,
      module.lambda_api.lambda_function_invoke_arn
    )
  })
}


/*
  Base Module
*/
module "vpce_interface_api_gw" {
  /*
    This VPC Endpoint interface is associated with the API Gateway
  */
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/interface?ref=aws-vpce-interface-v2.0.0"

  env          = var.env
  env_inst     = var.env_inst
  service_name = "execute-api"
  name         = local.app_name

  vpc_tag_name = format("%s-%s", var.vpc_name_prefix, local.env)
}

module "vpce_interface_api_gw_vpc_main" {
  /*
    This VPC Endpoint interface is configured in the interconnected VPC and used in the Target Private API Gateway's Resource Policy as the `sourceVpce` filter
  */
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/interface?ref=aws-vpce-interface-v2.0.0"

  env          = var.env
  env_inst     = var.env_inst
  service_name = "execute-api"
  name         = local.app_name

  vpc_tag_name = var.env == "qa" ? local.env : format("%s-%s", "main", local.env)
}