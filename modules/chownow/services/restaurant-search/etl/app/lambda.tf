module "restaurant_search_etl_kickoff_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.etl_kickoff_name}-${local.env}"
  lambda_cron_boolean     = var.etl_kickoff_cron
  lambda_image_config_cmd = var.etl_kickoff_lambda_handler
  lambda_description      = "Kicks off Restaurant Search ETL state machine in ${local.env}"
  lambda_ecr              = var.etl_kickoff_ecr
  lambda_image_uri        = var.etl_kickoff_image_uri
  lambda_memory_size      = var.etl_kickoff_memory_size
  lambda_runtime          = var.etl_kickoff_runtime
  lambda_s3               = var.etl_kickoff_s3
  service                 = var.service
  lambda_timeout          = 30
  lambda_env_variables    = local.etl_kickoff_lambda_env_vars

}

module "restaurant_search_etl_fetch_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.etl_fetch_name}-${local.env}"
  lambda_cron_boolean     = var.etl_fetch_cron
  lambda_image_config_cmd = var.etl_fetch_lambda_handler
  lambda_description      = "Task for Step Function: fetches data for restaurant in ${local.env}"
  lambda_ecr              = var.etl_fetch_ecr
  lambda_image_uri        = var.etl_fetch_image_uri
  lambda_memory_size      = var.etl_fetch_memory_size
  lambda_runtime          = var.etl_fetch_runtime
  lambda_s3               = var.etl_fetch_s3
  service                 = var.service
  lambda_timeout          = 30
  lambda_vpc_subnet_ids   = data.aws_subnets.private_base.ids
  lambda_vpc_sg_ids       = [module.ecs_sg.id]
  lambda_env_variables    = local.etl_fetch_lambda_env_vars
}

module "restaurant_search_etl_delete_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.etl_delete_name}-${local.env}"
  lambda_cron_boolean     = var.etl_delete_cron
  lambda_image_config_cmd = var.etl_delete_lambda_handler
  lambda_description      = "Task for Step Function: deletes data for restaurant in ${local.env}"
  lambda_ecr              = var.etl_delete_ecr
  lambda_image_uri        = var.etl_delete_image_uri
  lambda_memory_size      = var.etl_delete_memory_size
  lambda_runtime          = var.etl_delete_runtime
  lambda_s3               = var.etl_delete_s3
  service                 = var.service
  lambda_timeout          = 30
  lambda_env_variables    = local.etl_delete_lambda_env_vars
  lambda_vpc_subnet_ids   = data.aws_subnets.private_base.ids
  lambda_vpc_sg_ids       = [module.ecs_sg.id]

}

module "restaurant_search_etl_insert_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.etl_insert_name}-${local.env}"
  lambda_cron_boolean     = var.etl_insert_cron
  lambda_image_config_cmd = var.etl_insert_lambda_handler
  lambda_description      = "Task for Step Function: inserts data for restaurant in ${local.env}"
  lambda_ecr              = var.etl_insert_ecr
  lambda_image_uri        = var.etl_insert_image_uri
  lambda_memory_size      = var.etl_insert_memory_size
  lambda_runtime          = var.etl_insert_runtime
  lambda_s3               = var.etl_insert_s3
  service                 = var.service
  lambda_timeout          = 30
  lambda_env_variables    = local.etl_insert_lambda_env_vars
  lambda_vpc_subnet_ids   = data.aws_subnets.private_base.ids
  lambda_vpc_sg_ids       = [module.ecs_sg.id]

}
