module "verify_token" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Facebook verify token"
  env         = var.env
  secret_name = "verify_token"
  secret_key  = "verify_token"
  service     = local.app_name

  extra_tags = local.extra_tags
}

module "app_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Facebook app secret"
  env         = var.env
  secret_name = "app_secret"
  secret_key  = "app_secret"
  service     = local.app_name

  extra_tags = local.extra_tags
}

module "ops_api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Datadog api key"
  env         = var.env
  secret_name = "ops_api_key"
  service     = local.app_name

  extra_tags = local.extra_tags
}

module "sentry_dsn" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Sentry DSN"
  env         = var.env
  secret_name = "sentry_dsn"
  service     = local.app_name

  extra_tags = local.extra_tags
}
