# --- Secrets Manager secrets

locals {
  service_secret_names = toset([
    "redis_auth_token",
    "hmac_signature_key",
    "pos_square_oauth_client_secret",
    "sentry_url",
    "sf_api_password",
    "sf_api_security_token",
    "pos_vendor_webhook_signature_key",
    "steaks_webhook_url",
    "rds_db_details"
  ])
  secret_prefix = "${local.env}/${local.app_name}"
}

data "aws_secretsmanager_secret" "secrets" {
  for_each = local.service_secret_names
  name     = "${local.secret_prefix}/${each.key}"
}

# this one has a different structure so we can't trivially for_each it
# it's not pos-service specific anyway so it seems fair to split it out
data "aws_secretsmanager_secret" "dd_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}
