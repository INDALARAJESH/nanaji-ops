# Lambda
module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.4"

  env                   = local.env
  extra_tags            = local.extra_tags
  lambda_classification = "${local.app_name}_${lower(local.env)}"
  lambda_cron_boolean   = false
  lambda_description    = "This ${local.app_name} lambda manages integration with Facebook Business in ${local.env}"
  lambda_ecr            = var.lambda_ecr
  lambda_env_variables  = local.lambda_env_variables
  lambda_image_uri      = var.lambda_image_uri
  lambda_memory_size    = var.lambda_memory_size
  lambda_name           = var.name
  lambda_runtime        = var.lambda_runtime
  lambda_s3             = var.lambda_s3
  service               = local.app_name

}

# Lambda API Gateway Integration
module "api_gateway_lambda_integration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/lambda-integration?ref=aws-api-gateway-rest-lambda-integration-v2.0.0"

  access_log_settings = local.access_log_settings
  api_gateway_name    = var.api_gateway_name
  env                 = var.env
  env_inst            = var.env_inst
  extra_tags          = local.extra_tags
  lambda_arn          = module.function.lambda_function_arn
  lambda_invoke_arn   = module.function.lambda_function_invoke_arn
  path_prefix         = var.api_gateway_path_prefix

}

resource "aws_api_gateway_base_path_mapping" "api" {
  for_each = toset(local.domain_names)

  api_id      = data.aws_api_gateway_rest_api.api.id
  domain_name = each.key
  stage_name  = module.api_gateway_lambda_integration.stage_name

}
