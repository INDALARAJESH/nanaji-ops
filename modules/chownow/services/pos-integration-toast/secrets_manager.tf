# used to dynamically pull the Datadog API Key from Secrets Manager
# see: https://docs.datadoghq.com/serverless/installation/python/?tab=containerimage
resource "aws_secretsmanager_secret" "dd_api_key" {
  name = "${local.env}/${local.service}/dd_api_key"
}

module "launch_darkly_sdk_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.2"

  description = "LaunchDarkly SDK key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "launch_darkly_sdk_key"
  service     = local.service
}