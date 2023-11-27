module "dd_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "DataDog API key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "${var.service}_dd_api_key"
  service     = var.service
}

# this is actually for an SDK key
module "ld_api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "LaunchDarkly API key for Restaurant Search Project"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "ld_api_key"
  service     = var.service
}

module "hermosa_ld_sdk_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.2"

  description = "SDK key for LaunchDarkly"
  env         = local.env
  secret_name = "hermosa_launchdarkly_sdk_key"
  service     = "restaurant-search"
}
