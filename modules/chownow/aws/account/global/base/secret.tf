module "dd_ops_apikey" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.0"

  count = var.enable_secret_dd_ops_api

  description = "Datadog Ops API key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "ops_api_key"
  service     = "datadog"

  extra_tags = {
    FargateReadable = "true"
  }
}

module "github_pat" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  count = var.enable_secret_github_pat

  description = "GitHub PAT for frontend ${var.env}"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "github"
  secret_key  = "GITHUB_TOKEN"
  service     = "frontend"
  extra_tags  = local.common_tags

}
