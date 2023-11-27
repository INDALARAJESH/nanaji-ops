# Lambda
module "lambda_api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.7"

  env                             = local.env
  extra_tags                      = local.extra_tags
  lambda_classification           = format("%s-api-%s", local.app_name, lower(local.env))
  lambda_description              = format("%s-api in %s", local.app_name, local.env)
  lambda_name                     = format("%s-api-%s", local.app_name, lower(local.env))
  lambda_s3                       = false
  lambda_ecr                      = true
  lambda_image_uri                = var.image_uri
  lambda_cron_boolean             = false
  lambda_memory_size              = 256
  lambda_timeout                  = 15
  lambda_image_config_cmd         = "datadog_lambda.handler.handler"
  lambda_env_variables            = merge(local.lambda_common_env_variables, local.lambda_api_env_variables)
  lambda_runtime                  = var.lambda_runtime
  lambda_vpc_subnet_ids           = module.lambda_vpc_dependencies.private_subnet_ids
  lambda_vpc_sg_ids               = [module.lambda_vpc_dependencies.default_sg_id]
  lambda_tracing_enabled          = var.lambda_xray_tracing_enabled
  lambda_publish                  = true
  lambda_provisioned_concurrency  = var.enable_lambda_provisioned_concurrency # https://github.com/hashicorp/terraform-provider-aws/issues/13329
  lambda_autoscaling              = var.enable_lambda_autoscaling # https://github.com/hashicorp/terraform-provider-aws/issues/13329
  lambda_autoscaling_min_capacity = var.lambda_api_autoscaling_min_capacity
  lambda_autoscaling_max_capacity = var.lambda_api_autoscaling_max_capacity
  lambda_optional_policy_enabled  = true
  lambda_optional_policy_arn      = data.aws_iam_policy.lambda.arn
  service                         = local.app_name
}
