module "sns_to_slack_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.3"

  env                 = local.env
  lambda_name         = var.slack_lambda_name
  lambda_cron_boolean = false
  lambda_description  = var.slack_lambda_description
  lambda_handler      = var.slack_lambda_handler
  service             = var.service

  lambda_env_variables = {
    ENV                  = local.env
    SLACK_CHANNEL        = var.slack_lambda_env_slack_channel
    SLACK_ICON_EMOJI     = var.slack_lambda_env_slack_icon_emoji
    SLACK_USERNAME       = var.slack_lambda_env_slack_username
    SECRETS_MANAGER_PATH = data.aws_secretsmanager_secret.slack_webhook.name
  }

  lambda_layer_names = var.slack_lambda_layers
  domain             = "chownow.com"
}
