module "platform_app_signing_key_id" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v3.0.0"

  description = "APNS signing key id for Marketplace Live Activity Platform Application"
  env         = local.env
  secret_name = "apns_signing_key_id"
  service     = var.service
}

module "platform_app_signing_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v3.0.0"

  description = "APNS signing key for Marketplace Live Activity Platform Application"
  env         = local.env
  secret_name = "apns_signing_key"
  service     = var.service
}
