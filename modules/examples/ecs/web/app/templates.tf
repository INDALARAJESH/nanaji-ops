data "template_file" "ecs_app_policy_base" {
  template = file("${path.module}/templates/ecs_app_policy_base.json.tpl")

  vars = {
    aws_account_id      = data.aws_caller_identity.current.account_id
    aws_region          = data.aws_region.current.name
    datadog_secrets     = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog"
    env                 = var.env
    service             = var.service
    service_secrets_arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}"
  }
}

data "template_file" "web_td" {
  template = file("${path.module}/templates/web_td.json.tpl")

  vars = {
    aws_region            = data.aws_region.current.name
    awslogs_stream_prefix = "${var.service}-${var.web_name}"
    container_port        = var.container_port
    datadog_env           = local.datadog_env
    ecr_repo_url          = local.ecr_repo_url
    image_tag             = var.image_tag
    env                   = var.env
    name                  = local.web_container_name
    sentry_dsn            = var.sentry_dsn

    # Log Configuration
    lc_apikey_arn      = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = "env:${local.env},role:${var.web_name}"
    lc_service         = var.service

    # Firelens Configuration
    cwlogs_name        = "${var.service}-${var.web_name}-log-group-${local.env}"
    cwlogs_prefix      = var.web_name
    log_container_name = var.firelens_container_name
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_image_version  = var.firelens_container_image_version
  }
}
