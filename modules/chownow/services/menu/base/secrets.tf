module "jwt_auth_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "JWT auth secret"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "jwt_auth_secret"
  service     = var.service
}

module "ld_sdk_key_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "LaunchDarkly API SDK Key Secret"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "ld_sdk_key_secret"
  service     = var.service

}
