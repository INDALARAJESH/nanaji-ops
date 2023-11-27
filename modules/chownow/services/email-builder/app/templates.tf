data "template_file" "email_builder_ecs_app_policy_base" {
  template = file("${path.module}/templates/email_builder_ecs_app_policy_base.json.tpl")

  vars = {
    aws_account_id            = data.aws_caller_identity.current.account_id
    aws_region                = data.aws_region.current.name
    env                       = var.env
    service                   = var.service
    service_secrets_arn       = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}"
    datadog_secrets           = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog"
    service_email_builder_arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}"
    api_key_arn               = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}/api_key"
  }
}

data "template_file" "email_builder_td_api" {
  template = file("${path.module}/templates/email_builder_td_api.json.tpl")

  vars = {
    aws_region               = data.aws_region.current.name
    awslogs_stream_prefix    = "${var.service}-api"
    container_port           = var.container_port
    host_port                = var.host_port
    ecr_repo_url             = local.ecr_image_repo
    image_tag                = var.image_tag
    env                      = var.env
    log_group                = "${var.service}-api-log-group-${local.env}"
    name                     = local.container_name
    td_env_loyalty_log_level = var.email_builder_log_level
    sentry_dsn               = var.sentry_dsn

    # Logs Configuration
    lc_apikey_arn      = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = "env:${local.env},role:api"
    lc_service         = var.service

    # Firelens Configuration
    cwlogs_region      = local.region
    cwlogs_name        = "${var.service}-api-log-group-${local.env}"
    cwlogs_prefix      = "api"
    log_container_name = var.firelens_container_name
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_image_version  = var.firelens_container_image_version

    # Secrets
    td_env_secret_gmail_username = data.aws_secretsmanager_secret_version.gmail_username.secret_id
    td_env_secret_gmail_password = data.aws_secretsmanager_secret_version.gmail_password.secret_id
  }
}
