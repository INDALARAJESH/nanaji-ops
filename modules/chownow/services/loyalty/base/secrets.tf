module "sentry_dsn" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Sentry DSN"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sentry_dsn"
  service     = var.service
}

module "launchdarkly_sdk_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "LaunchDarkly SDK KEY"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "launchdarkly_sdk_key"
  service     = var.service
}
