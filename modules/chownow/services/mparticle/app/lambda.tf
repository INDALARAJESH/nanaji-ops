# Lambda
module "iterable_rules" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.4"

  env                   = local.env
  extra_tags            = local.extra_tags
  lambda_classification = local.ir_lambda_classification
  lambda_cron_boolean   = false
  lambda_description    = "This ${local.ir_app_name} lambda triggers Iterable Rules for MParticle in ${local.env}"
  lambda_ecr            = var.lambda_ecr
  lambda_env_variables  = local.lambda_env_variables
  lambda_image_uri      = var.lambda_image_uri
  lambda_memory_size    = var.lambda_memory_size
  lambda_name           = var.name
  lambda_runtime        = var.lambda_runtime
  lambda_s3             = var.lambda_s3
  service               = local.ir_app_name

}
