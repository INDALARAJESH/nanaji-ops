# Lambda
module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.3"

  env                   = local.env
  lambda_description    = var.lambda_description
  lambda_name           = var.name
  service               = var.service
  lambda_classification = "${lower(var.name)}-${lower(var.service)}_${lower(local.env)}"
  lambda_runtime        = var.lambda_runtime
  lambda_env_variables  = var.lambda_env_variables
  lambda_cron_boolean   = false
  lambda_s3             = var.lambda_s3
  lambda_ecr            = var.lambda_ecr
  lambda_image_uri      = var.lambda_image_uri
  extra_tags            = var.extra_tags
}

# Lambda API Integration
module "api_gateway_lambda_integration" {
  source              = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/lambda-integration?ref=aws-api-gateway-rest-lambda-integration-v2.0.0"
  depends_on          = [module.function]
  env                 = var.env
  env_inst            = var.env_inst
  extra_tags          = var.extra_tags
  api_gateway_name    = var.api_gateway_name
  lambda_arn          = module.function.lambda_function_arn
  lambda_invoke_arn   = module.function.lambda_function_invoke_arn
  path_prefix         = var.path_prefix
  access_log_settings = var.access_log_settings
}

resource "aws_api_gateway_base_path_mapping" "api" {
  depends_on  = [module.api_gateway_lambda_integration]
  for_each    = toset(var.domain_names)
  api_id      = data.aws_api_gateway_rest_api.api.id
  stage_name  = module.api_gateway_lambda_integration.stage_name
  domain_name = each.key
}
