module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.8"

  env                            = local.env
  extra_tags                     = local.extra_tags
  lambda_classification          = local.lambda_classification
  lambda_cron_boolean            = var.lambda_cron_boolean
  lambda_image_config_cmd        = var.lambda_handler
  lambda_description             = "ETL for OBN channels data from Snowflake"
  lambda_ecr                     = var.lambda_ecr
  lambda_env_variables           = local.lambda_env_variables
  lambda_image_uri               = var.lambda_image_uri
  lambda_memory_size             = var.lambda_memory_size
  lambda_name                    = var.lambda_name
  lambda_runtime                 = var.lambda_runtime
  lambda_s3                      = var.lambda_s3
  lambda_timeout                 = 900
  lambda_vpc_subnet_ids          = var.vpc_placement_subnets
  lambda_vpc_sg_ids              = [aws_security_group.cds_membership.id]
  service                        = var.service
  cloudwatch_schedule_expression = var.cloudwatch_schedule_expression

}
