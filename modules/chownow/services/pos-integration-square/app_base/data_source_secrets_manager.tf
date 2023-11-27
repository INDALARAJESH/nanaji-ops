# --- Secrets Manager secrets

# this one has a different structure so we can't trivially for_each it
# it's not pos-service specific anyway so it seems fair to split it out
data "aws_secretsmanager_secret" "dd_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}
