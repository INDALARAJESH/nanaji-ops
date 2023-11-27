module "api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Email Builder Service API Key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "api_key"
  service     = var.service
}

module "gmail_username" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Gmail SMTP username"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "gmail_username"
  service     = var.service
}

module "gmail_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Gmail SMTP password"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "gmail_password"
  service     = var.service
}

module "launch_darkly_sdk_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "LaunchDarkly SDK key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "launch_darkly_sdk_key"
  service     = var.service
}
