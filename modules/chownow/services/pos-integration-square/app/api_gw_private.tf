module "rest_api_gateway_openapi_private" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/gateway-private-openapi?ref=aws-api-gateway-rest-gateway-private-openapi-v2.0.1"

  name       = format("%s-private", local.app_name)
  env        = var.env
  env_inst   = var.env_inst
  extra_tags = local.extra_tags

  # these are used for resource policy for this private api gw
  source_vpc_endpoint_ids = compact([
    concat(data.aws_vpc_endpoint.api_gw_private_vpce_env.*.id, [""])[0],
    concat(var.api_gateway_priv_vpce_list, [""])[0],
    data.aws_vpc_endpoint.api_gw_private.id
  ])
  vpc_endpoint_ids = [data.aws_vpc_endpoint.api_gw_private.id]

  # this apigw-spec.json is already jsonencoded()
  openapi_spec_json = templatefile(format("%s/templates/apigw.private.json", path.module), {
    api-lambda-invoke-arn = coalesce(
      module.lambda_api.lambda_function_invoke_arn_alias_newest,
      module.lambda_api.lambda_function_invoke_arn
    )
  })
}

module "rest_api_gateway_openapi_private_deployment" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/deployment?ref=aws-api-gateway-rest-deployment-v2.0.1"

  env      = var.env
  env_inst = var.env_inst

  api_id              = module.rest_api_gateway_openapi_private.api_id
  create_api_key      = true
  access_log_settings = local.access_log_settings

  redeployment_trigger = [
    module.rest_api_gateway_openapi_private.openapi_spec_checksum,
    module.rest_api_gateway_openapi_private.api_gw_resource_policy_checksum
  ]

  extra_tags = local.extra_tags
}

# original comments from netguru:
#   You can apply the policy at the function level, OR specify a qualifier to restrict access to a single version or alias.
#   If you use a qualifier, the invoker must use the full Amazon Resource Name (ARN) of that version or alias to invoke the function.

#   https://docs.aws.amazon.com/apigateway/latest/developerguide/arn-format-reference.html#apigateway-v1-arns
#   source_arn must match: `arn:partition:execute-api:region:account-id:api-id/stage/http-method/resource-path`
#     `api-id/*/GET/*` – GET method on all resources in all stages.
#     api-id/prod/ANY/user – ANY method on the user resource in the prod stage.
#     -> api-id/*/*/* – All methods on all resources in all stages.

resource "aws_lambda_permission" "api_gw_private_invoke_lambda_api_alias_newest" {
  # Permission to invoke the function published with alias
  statement_id_prefix = format("AllowExecutionForAliasNewestFromAPIGatewayId_%s_", module.rest_api_gateway_openapi_private.api_id)
  action              = "lambda:InvokeFunction"
  function_name       = module.lambda_api.lambda_function_arn
  principal           = "apigateway.amazonaws.com"
  qualifier           = "newest"

  source_arn = format("arn:aws:execute-api:%s:%s:%s/*/*/*",
    data.aws_region.current.name,
    data.aws_caller_identity.current.id,
    module.rest_api_gateway_openapi_private.api_id
  )
}

