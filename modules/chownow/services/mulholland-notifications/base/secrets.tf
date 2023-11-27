module "slack_hooks" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Slack hooks for mulholland-notifications in the ${var.env} environment"
  env         = var.env
  secret_name = "slack-hooks"
  service     = var.service
}
