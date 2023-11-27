# General Secrets

module "slack_token" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Slack token for errbot"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "slack_bot_token"
  service     = var.service
}

module "slack_app_token" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Slack app token for errbot"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "slack_app_token"
  service     = var.service
}

module "slack_signing_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Slack signing secret for errbot"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "slack_signing_secret"
  service     = var.service
}

module "jenkins_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Password for Jenkins User used by errbot"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "jenkins_password"
  service     = var.service
}

module "bot_admins" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "List of bot admins who have access to errbot"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "bot_admins"
  service     = var.service
}
