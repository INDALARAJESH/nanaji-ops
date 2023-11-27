module "mul_notifications_slack_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.4"

  env                   = local.env
  extra_tags            = local.extra_tags
  lambda_classification = "${var.mul_notifications_slack_name}-${lower(local.env)}"
  lambda_cron_boolean   = var.mul_notifications_slack_cron
  lambda_description    = "Manages mulholland slack notifications in ${local.env}"
  lambda_ecr            = var.mul_notifications_slack_ecr
  lambda_image_uri      = var.mul_notifications_slack_image_uri
  lambda_memory_size    = var.mul_notifications_slack_memory_size
  lambda_runtime        = var.mul_notifications_slack_runtime
  lambda_s3             = var.mul_notifications_slack_s3
  service               = var.service
  lambda_timeout        = 30
  lambda_env_variables  = local.mul_notifications_slack_env_vars

}
