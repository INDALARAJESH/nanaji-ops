# --- Secrets Manager secrets

data "aws_secretsmanager_secret" "dd_api_key" {
  name = format("%s/datadog/ops_api_key", local.env)
}

data "aws_secretsmanager_secret" "hermosa_api_key_user_privacy_lambda" {
  name = "${local.env}/${local.app_name}/hermosa_api_key_user_privacy_lambda"
}

data "aws_secretsmanager_secret" "one_trust_client_id" {
  name = "${local.env}/${local.app_name}/one_trust_client_id"
}

data "aws_secretsmanager_secret" "one_trust_client_secret" {
  name = "${local.env}/${local.app_name}/one_trust_client_secret"
}
