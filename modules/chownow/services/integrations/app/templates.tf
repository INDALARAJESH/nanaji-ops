data "template_file" "web_td" {
  template = file("${path.module}/templates/web_ecs_td.json.tpl")

  vars = {
    env               = local.env
    datadog_env       = local.datadog_env
    name              = local.web_container_name
    image_repo        = var.web_ecr_repository_uri
    image_version     = var.web_container_image_version
    container_port    = var.web_container_port
    deployment_suffix = var.deployment_suffix

    # firelens
    cwlogs_region      = local.region
    cwlogs_name        = module.ecs_base_web.cloudwatch_log_group_name
    cwlogs_prefix      = "web"
    log_container_name = var.firelens_container_name
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_image_version  = var.firelens_container_image_version

    # logConfiguration
    lc_apikey_arn      = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = "env:${local.datadog_env},aws_env:${local.env},role:web,deployment_suffix:${var.deployment_suffix}"
    lc_service         = local.service

    # environmentFile
    td_env_file_path = module.env_file_bucket.bucket_arn

    # secrets
    td_env_secret_email_password        = data.aws_secretsmanager_secret_version.ses_password.secret_id
    td_env_secret_email_user            = data.aws_secretsmanager_secret_version.ses_user.secret_id
    td_env_secret_hermosa_api_key       = data.aws_secretsmanager_secret_version.hermosa_api_key.secret_id
    td_env_secret_new_relic_license_key = data.aws_secretsmanager_secret_version.new_relic_license_key.secret_id
    td_env_secret_postgres_password     = data.aws_secretsmanager_secret_version.postgres_password.secret_id
    td_env_secret_redis_auth_token      = data.aws_secretsmanager_secret_version.redis_auth_token.secret_id
    td_env_secret_secret_key            = data.aws_secretsmanager_secret_version.secret_key.secret_id
    td_env_secret_sentry_dsn            = data.aws_secretsmanager_secret_version.sentry_dsn.secret_id
    td_env_secret_slack_menu_webhook    = data.aws_secretsmanager_secret_version.slack_menu_webhook.secret_id
    td_env_secret_datadog_api_key       = data.aws_secretsmanager_secret_version.datadog_api_key.secret_id
  }
}

data "template_file" "manage_td" {
  template = file("${path.module}/templates/manage_ecs_td.json.tpl")

  vars = {
    env               = local.env
    name              = local.manage_container_name
    image_repo        = var.manage_ecr_repository_uri
    image_version     = var.manage_container_image_version
    container_port    = var.manage_container_port
    deployment_suffix = var.deployment_suffix
    hermosa_api_url   = var.hermosa_api_url

    # firelens
    cwlogs_region      = local.region
    cwlogs_name        = module.ecs_base_web.cloudwatch_log_group_name
    cwlogs_prefix      = "manage"
    log_container_name = var.firelens_container_name
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_image_version  = var.firelens_container_image_version

    # logConfiguration
    lc_apikey_arn      = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = "env:${local.datadog_env},aws_env:${local.env},role:manage,deployment_suffix:${var.deployment_suffix}"
    lc_service         = local.service

    # environment
    td_env_file_path = module.env_file_bucket.bucket_arn

    # secrets
    td_env_secret_hermosa_api_key   = data.aws_secretsmanager_secret_version.hermosa_api_key.secret_id
    td_env_secret_pgmaster_password = data.aws_secretsmanager_secret_version.pgmaster_password.secret_id
    td_env_secret_postgres_password = data.aws_secretsmanager_secret_version.postgres_password.secret_id
    td_env_secret_redis_auth_token  = data.aws_secretsmanager_secret_version.redis_auth_token.secret_id
    td_env_secret_secret_key        = data.aws_secretsmanager_secret_version.secret_key.secret_id
  }
}

data "template_file" "manage_event_target" {
  template = file("${path.module}/templates/manage_event_target.json.tpl")

  vars = {
    name    = local.manage_container_name
    command = var.event_container_override_command
  }
}
