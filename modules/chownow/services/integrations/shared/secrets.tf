module "hermosa_api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  env         = var.env
  env_inst    = var.env_inst
  description = "Token to enable communication between ${upper(var.service)} and hermosa"
  secret_name = "hermosa_api_key"
  service     = "shared-${var.service}"
}

module "new_relic_license_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "${upper(var.service)} New Relic license key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "new_relic_license_key"
  service     = "shared-${var.service}"
}

module "sentry_dsn" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "${upper(var.service)} application secret key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sentry_dsn"
  service     = "shared-${var.service}"
}

module "ses_user" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "SES user to be used by ${upper(var.service)}"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "ses_user"
  service     = "shared-${var.service}"
}

module "ses_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "SES password to be used by ${upper(var.service)}"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "ses_password"
  service     = "shared-${var.service}"
}

module "slack_menu_webhook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Slack WebHook to be used for Menu API notifications by ${upper(var.service)}"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "slack_menu_webhook"
  service     = "shared-${var.service}"
}

module "datadog_api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Datadog API key used for monitoring by ${upper(var.service)}"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "datadog_api_key"
  service     = "shared-${var.service}"
}
