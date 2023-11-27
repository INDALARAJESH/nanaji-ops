module "api_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/rest-api-lambda?ref=rest-api-lambda-v2.0.1"

  env                  = local.env
  name                 = var.name
  service              = var.service
  api_gateway_name     = var.api_gateway_name
  domain_names         = var.domain_names
  lambda_description   = var.lambda_description
  lambda_runtime       = var.lambda_runtime
  lambda_env_variables = var.lambda_env_variables
  path_prefix          = var.path_prefix
  lambda_s3            = var.lambda_s3
  lambda_ecr           = var.lambda_ecr
  lambda_image_uri     = var.lambda_image_uri
  access_log_settings  = var.access_log_settings
  extra_tags           = var.extra_tags
}
