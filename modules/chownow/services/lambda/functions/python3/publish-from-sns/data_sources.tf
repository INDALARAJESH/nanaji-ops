data "aws_secretsmanager_secret" "slack_webhook" {
  name = local.slack_webhook_secret_path
}
