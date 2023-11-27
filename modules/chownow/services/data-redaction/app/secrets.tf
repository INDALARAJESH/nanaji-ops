module "datadog_api_key_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "datadog api key for ${var.service} service"
  env         = var.env
  secret_name = "dd_api_key"
  service     = var.service
}
