module "slack_webhook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.0"

  count = var.enable_secret_slack_webhook

  description = "slack webhook for ops alerts"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "webhook"
  service     = "slack"

  extra_tags = local.extra_tags
}
