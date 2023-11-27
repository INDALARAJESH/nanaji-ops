module "user_privacy_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.service}-${local.user_privacy_lambda_name}-${lower(local.env)}"
  lambda_cron_boolean     = false
  lambda_image_config_cmd = var.lambda_handler
  lambda_description      = "Processing the OneTrust(CCPA) webhook requests"
  lambda_ecr              = var.lambda_ecr
  lambda_image_uri        = var.user_privacy_lambda_image_uri
  lambda_memory_size      = var.lambda_memory_size
  lambda_runtime          = var.lambda_runtime
  lambda_s3               = false
  service                 = var.service
  lambda_timeout          = 300
  lambda_vpc_subnet_ids   = module.lambda_vpc_dependencies.private_subnet_ids
  lambda_vpc_sg_ids       = [module.lambda_vpc_dependencies.default_sg_id]
  lambda_env_variables = merge(
    local.lambda_env_variables_common,
    local.lambda_env_variables_user_privacy
  )
}

locals {
  user_privacy_lambda_name = "service"
}
