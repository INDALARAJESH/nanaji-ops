module "one_trust_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Secret key to generate the API token for OneTrust"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "one_trust_client_secret" # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name            # local.service
}

module "one_trust_client_id" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "ClientID to generate the API token for OneTrust"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "one_trust_client_id" # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name        # local.service
}

module "hermosa_api_key_user_privacy" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Used to authenticate the UserDataRequestsService request (from Lambda) in Hermosa"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "hermosa_api_key_user_privacy_lambda" # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name                        # local.service
}
