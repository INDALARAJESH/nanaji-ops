###########
# Logging #
###########

resource "aws_cloudwatch_log_group" "app" {
  name              = "dms-web-log-group-${local.env}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name = "dms-web-log-group-${local.env}"
  }
}

# This lookup provides the ecr repo and container image for the amazon provided
# logging sidecar image for firelens/fluentbit logging to datadog
data "aws_ssm_parameter" "fluentbit" {
  name = "${var.firelens_container_ssm_parameter_name}/${var.firelens_container_image_version}"
}

data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.dd_ops_api_key.id
  version_stage = "AWSCURRENT"
}
