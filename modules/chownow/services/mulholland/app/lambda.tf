module "mulholland_2fa_integration_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.4"

  env                   = local.env
  extra_tags            = local.extra_tags
  lambda_classification = "${var.mul_2fa_integration_name}-${lower(local.env)}"
  lambda_cron_boolean   = var.mul_2fa_integration_cron
  lambda_description    = "Manages integration with 2fa via api gateway in ${local.env}"
  lambda_ecr            = var.mul_2fa_integration_ecr
  lambda_image_uri      = var.mul_2fa_image_uri
  lambda_memory_size    = var.mul_2fa_integration_memory_size
  lambda_runtime        = var.mul_2fa_integration_runtime
  lambda_s3             = var.mul_2fa_integration_s3
  service               = var.service
  lambda_timeout        = 15
  lambda_env_variables  = local.mul_2fa_env_vars

}
