# --- Secrets Manager secrets
# Runbook on updating and/or rotating these secrets:
# https://chownow.atlassian.net/wiki/spaces/MOB/pages/2805006762/Updating+SFDC+Secrets+and+Credentials

data "aws_secretsmanager_secret" "dd_api_key" {
  name = format("%s/datadog/ops_api_key", local.env)
}

data "aws_secretsmanager_secret" "sfdc_token" {
  name = "${local.env}/${local.app_name}/sfdc_token"
}

data "aws_secretsmanager_secret" "sfdc_client_secret" {
  name = "${local.env}/${local.app_name}/sfdc_client_secret"
}

data "aws_secretsmanager_secret" "sfdc_password" {
  name = "${local.env}/${local.app_name}/sfdc_password"
}
