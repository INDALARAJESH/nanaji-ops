module "ir_ops_api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Datadog api key for iterable rule lambda"
  env         = var.env
  secret_name = "ops_api_key"
  service     = "${local.ir_app_name}-${var.service}"

  extra_tags = local.extra_tags
}
