module "rest_api_gateway_openapi_public" {
  source     = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/gateway-openapi?ref=aws-api-gateway-rest-gateway-openapi-v2.0.0"
  name       = format("%s-public", local.app_name)
  env        = var.env
  env_inst   = var.env_inst
  extra_tags = local.extra_tags

  # this apigw-spec.json is already jsonencoded()
  openapi_spec_json = templatefile(format("%s/templates/apigw.all.json", path.module), {
    api-lambda-invoke-arn = coalesce(
      module.lambda_api.lambda_function_invoke_arn_alias_newest,
      module.lambda_api.lambda_function_invoke_arn
    )
  })
}