# General Secrets
module "sfdc_username" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Salesforce username for ${upper(var.service)}"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "sfdc_username"
  service     = "${var.service}"
}

module "sfdc_password" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Salesforce password for ${upper(var.service)}"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "sfdc_password"
  service     = "${var.service}"
}

module "sfdc_integration_user" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Salesforce integration user for ${upper(var.service)}"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "sfdc_integration_user"
  service     = "${var.service}"
}

module "sfdc_integration_password" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Salesforce integration password for ${upper(var.service)}"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "sfdc_integration_password"
  service     = "${var.service}"
}

module "redis_auth_token" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Auth token for ${upper(var.service)} redis"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "redis_auth_token"
  service     = "${var.service}"
}

# API Secrets
module "delighted_api_key" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Delighted API key for connectivity from ${upper(var.service)} to service"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "delighted_api_key"
  service     = "${var.service}"
}

module "sentry_dsn" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Sentry URL for ${upper(var.service)}"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "sentry_dsn"
  service     = "${var.service}"
}

module "sfdc_api_key" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "SalesForce API key for ${upper(var.service)}"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "sfdc_api_key"
  service     = "${var.service}"
}

module "sfdc_api_secret" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/create?ref=aws-secrets-v1.0.1"
  description = "Salesforce API secret for ${upper(var.service)}"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "sfdc_api_secret"
  service     = "${var.service}"
}
