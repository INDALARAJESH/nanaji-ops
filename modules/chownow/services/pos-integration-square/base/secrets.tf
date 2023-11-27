resource "random_password" "hmac_signature_key" {
  length           = 32
  lower            = false
  upper            = false
  number           = true
  special          = true
  override_special = "abcdef" # hexadecimal only
}

module "hmac_signature_key_insert" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = var.env
  env_inst           = var.env_inst
  secret_description = "HMAC_SIGNATURE_KEY used for restaurant_id signing while generating auth url"
  secret_name        = format("%s/%s/%s", var.env, local.app_name, "hmac_signature_key")
  secret_plaintext   = format("%s", random_password.hmac_signature_key.result)
  service            = local.service
}

module "sentry_url" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "SENTRY_URL -- used to connect to Sentry API"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = format("%s", "sentry_url") # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name             # local.service
}

module "pos_square_oauth_client_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "POS_VENDOR_OAUTH_CLIENT_SECRET -- used to connect to POS SQUARE API"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = format("%s", "pos_square_oauth_client_secret") # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name                                 # local.service
}

module "sf_api_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "SF_API_PASSWORD -- used to connect to SalesForce API"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = format("%s", "sf_api_password") # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name                  # local.service
}

module "sf_api_security_token" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "SF_API_SECURITY_TOKEN -- used to connect to SalesForce API"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = format("%s", "sf_api_security_token") # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name                        # local.service
}

module "pos_vendor_webhook_signature_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "POS_VENDOR_WEBHOOK_SIGNATURE_KEY -- used to validate POS SQUARE WEBHOOK Signature"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = format("%s", "pos_vendor_webhook_signature_key") # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name                                   # local.service
}

module "steaks_webhook_url" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "STEAKS_WEBHOOK_URL_ARN_SECRET_KEY -- Slack webhook"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = format("%s", "steaks_webhook_url") # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name                     # local.service
}


