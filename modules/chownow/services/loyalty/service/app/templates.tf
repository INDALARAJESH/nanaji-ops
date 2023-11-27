data "template_file" "loyalty_ecs_app_policy_base" {
  template = file("${path.module}/templates/loyalty_ecs_app_policy_base.json.tpl")

  vars = {
    aws_account_id           = data.aws_caller_identity.current.account_id
    aws_region               = data.aws_region.current.name
    env                      = local.env
    service                  = var.service
    service_api_key_arn      = data.aws_secretsmanager_secret.loyalty_api_key.arn
    datadog_ops_api_key_arn  = data.aws_secretsmanager_secret.datadog_ops_api_key.arn
    launchdarkly_api_key_arn = data.aws_secretsmanager_secret.launchdarkly_sdk_key.arn
    sentry_dsn_arn           = data.aws_secretsmanager_secret.sentry_dsn.arn
    dynamodb_table_arn       = data.aws_dynamodb_table.existing_table.arn
    dynamodb_table           = local.table_name
    sqs_queue_arn            = data.aws_sqs_queue.existing_queue.arn
  }
}

data "template_file" "loyalty_td_api" {
  template = file("${path.module}/templates/loyalty_td_api.json.tpl")

  vars = {
    aws_region               = data.aws_region.current.name
    awslogs_stream_prefix    = "${var.service}-api"
    container_entrypoint     = var.container_entrypoint
    container_port           = var.container_port
    host_port                = var.host_port
    ecr_repo_url             = var.image_repository_arn
    image_tag                = var.image_tag
    env                      = local.env
    datadog_env              = local.datadog_env
    launchdarkly_enabled     = var.launchdarkly_enabled
    log_group                = "${var.service}-log-group-${local.env}"
    name                     = local.container_name
    td_env_loyalty_log_level = var.loyalty_log_level
    td_env_dynamodb_table    = local.table_name
    sentry_dsn_arn           = data.aws_secretsmanager_secret.sentry_dsn.arn
    launchdarkly_api_key_arn = data.aws_secretsmanager_secret.launchdarkly_sdk_key.arn
    td_dd_service_mapping    = var.dd_service_mapping
    td_env_sqs_queue         = local.sqs_queue_name
    service_api_key_arn      = data.aws_secretsmanager_secret.loyalty_api_key.arn

    # Logs Configuration
    lc_apikey_arn      = data.aws_secretsmanager_secret.datadog_ops_api_key.arn
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = "env:${local.env},role:api"
    lc_service         = var.service

    # Firelens Configuration
    cwlogs_region      = data.aws_region.current.name
    cwlogs_name        = "${var.service}-log-group-${local.env}"
    cwlogs_prefix      = "api"
    log_container_name = var.firelens_container_name
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_image_version  = var.firelens_container_image_version
  }
}
