module "hermosa_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-image?ref=aws-lambda-image-v2.0.0"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = local.lambda_classification
  lambda_cron_boolean     = false
  lambda_description      = "Hermosa event entrypoint"
  lambda_env_variables    = local.lambda_env_variables
  lambda_image_config_cmd = var.lambda_image_config_cmd
  lambda_image_uri        = local.lambda_image_uri
  lambda_memory_size      = var.lambda_memory_size
  lambda_name             = var.lambda_name
  lambda_timeout          = var.lambda_timeout
  lambda_vpc_subnet_ids   = module.lambda_vpc_dependencies.private_subnet_ids
  lambda_vpc_sg_ids       = [data.aws_security_group.internal_allow.id, module.lambda_vpc_dependencies.default_sg_id]
  service                 = var.service
  with_lifecycle          = false

  lambda_reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
}

module "hermosa_low_priority_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-image?ref=aws-lambda-image-v2.0.0"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = local.lambda_low_priority_classification
  lambda_cron_boolean     = false
  lambda_description      = "Hermosa low priority event entrypoint"
  lambda_env_variables    = local.lambda_env_variables
  lambda_image_config_cmd = var.lambda_image_config_cmd
  lambda_image_uri        = local.lambda_image_uri
  lambda_memory_size      = var.lambda_memory_size
  lambda_name             = var.lambda_low_priority_name
  lambda_timeout          = var.lambda_low_priority_timeout
  lambda_vpc_subnet_ids   = module.lambda_vpc_dependencies.private_subnet_ids
  lambda_vpc_sg_ids       = [data.aws_security_group.internal_allow.id, module.lambda_vpc_dependencies.default_sg_id]
  service                 = var.service
  with_lifecycle          = false

  lambda_reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
}
