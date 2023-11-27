data "aws_secretsmanager_secret" "ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.ops_api_key.id
  version_stage = "AWSCURRENT"
}
