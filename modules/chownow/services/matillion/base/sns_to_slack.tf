module "slack_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Slack webhook"
  env         = local.env
  secret_name = "slack/webhook"
  service     = var.service
}

module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/functions/python3/publish-from-sns?ref=cn-lambda-publish-from-sns-v2.0.0"

  env                             = var.env
  slack_lambda_layers             = local.lambda_layers
  slack_webhook_secret_path       = "${local.env}/${var.service}/slack/webhook"
  depends_on                      = [module.slack_secret]
  slack_lambda_env_slack_channel  = "team-dna-alerts"
  slack_lambda_env_slack_username = "Matillion"
}
