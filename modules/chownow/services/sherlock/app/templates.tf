data "template_file" "sherlock_ecs_app_policy_base" {
  template = "${file("${path.module}/templates/sherlock_ecs_app_policy_base.json.tpl")}"

  vars = {
    aws_account_id      = "${data.aws_caller_identity.current.account_id}"
    aws_region          = "${data.aws_region.current.name}"
    env                 = "${var.env}"
    service             = "${var.service}"
    service_secrets_arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.env}/${var.service}"
    datadog_secrets     = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog"

    dynamodb_table      = "${var.service}-dynamodb-${local.env}"
  }
}

data "template_file" "sherlock_td_api" {
  template = "${file("${path.module}/templates/sherlock_td_api.json.tpl")}"

  vars = {
    aws_region                              = "${data.aws_region.current.name}"
    awslogs_stream_prefix                   = "${var.service}-api"
    container_entrypoint                    = "${var.container_entrypoint}"
    container_port                          = "${var.container_port}"
    host_port                               = "${var.container_port}"
    ecr_repo_url                            = "${module.sherlock_ecr.repo_url}"
    env                                     = "${var.env}"
    log_group                               = "${var.service}-log-group-${local.env}"
    name                                    = "${local.container_name}"
    td_env_sherlock_log_level               = "${var.sherlock_log_level}"
    td_env_dynamodb_table                   = "${var.service}-dynamodb-${local.env}"
    td_env_redis_host                       = "${var.service}-redis.${local.env}.aws.${var.domain}"
    td_env_redis_port                       = "${var.redis_port}"
    td_env_app_dashboard_url                = "${var.app_dashboard_url}"
    td_env_secret_sfdc_username             = "${data.aws_secretsmanager_secret_version.sfdc_username.secret_id}"
    td_env_secret_sfdc_password             = "${data.aws_secretsmanager_secret_version.sfdc_password.secret_id}"
    td_env_secret_sfdc_integration_user     = "${data.aws_secretsmanager_secret_version.sfdc_integration_user.secret_id}"
    td_env_secret_sfdc_integration_password = "${data.aws_secretsmanager_secret_version.sfdc_integration_password.secret_id}"
    td_env_secret_sfdc_api_key              = "${data.aws_secretsmanager_secret_version.sfdc_api_key.secret_id}"
    td_env_secret_sfdc_api_secret           = "${data.aws_secretsmanager_secret_version.sfdc_api_secret.secret_id}"
    td_env_secret_sentry_dsn                = "${data.aws_secretsmanager_secret_version.sentry_dsn.secret_id}"
    td_env_secret_redis_auth_token          = "${data.aws_secretsmanager_secret_version.redis_auth_token.secret_id}"

    # Logs Configuration
    lc_apikey_arn      = "${data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id}"
    lc_options_dd_host = "${var.firelens_options_dd_host}"
    lc_options_dd_tags = "env:${local.env},role:api"
    lc_service         = "${var.service}"

    # Firelens Configuration
    cwlogs_region      = "${local.region}"
    cwlogs_name        = "${var.service}-log-group-${local.env}"
    cwlogs_prefix      = "api"
    log_container_name = "${var.firelens_container_name}"
    log_image_repo     = "${data.aws_ssm_parameter.fluentbit.value}"
    log_image_version  = "${var.firelens_container_image_version}"
  }
}

data "template_file" "sherlock_td_scanner" {
  template = "${file("${path.module}/templates/sherlock_td_scanner.json.tpl")}"

  vars = {
    aws_region                              = "${data.aws_region.current.name}"
    awslogs_stream_prefix                   = "${var.service}-scanner"
    container_entrypoint                    = "${var.container_entrypoint}"
    container_port                          = "${var.container_port}"
    ecr_repo_url                            = "${module.sherlock_ecr.repo_url}"
    env                                     = "${var.env}"
    log_group                               = "${var.service}-log-group-${local.env}"
    host_port                               = "${var.container_port}"
    name                                    = "${var.service}-scanner"
    service                                 = "${var.service}"
    td_env_sherlock_log_level               = "${var.sherlock_log_level}"
    td_env_dynamodb_table                   = "${var.service}-dynamodb-${local.env}"
    td_env_redis_host                       = "${var.service}-redis.${local.env}.aws.${var.domain}"
    td_env_redis_port                       = "${var.redis_port}"
    td_env_node_env                         = "${var.env}"
    td_env_sfdc_login                       = "${var.sfdc_login}"
    td_env_sfdc_recordtype_id               = "${var.sfdc_recordtype_id}"
    td_env_consecutive_threshold            = "${var.consecutive_threshold}"
    td_env_percentage_to_scan               = "${var.percentage_to_scan}"
    td_env_secret_sfdc_username             = "${data.aws_secretsmanager_secret_version.sfdc_username.secret_id}"
    td_env_secret_sfdc_password             = "${data.aws_secretsmanager_secret_version.sfdc_password.secret_id}"
    td_env_secret_sfdc_integration_user     = "${data.aws_secretsmanager_secret_version.sfdc_integration_user.secret_id}"
    td_env_secret_sfdc_integration_password = "${data.aws_secretsmanager_secret_version.sfdc_integration_password.secret_id}"
    td_env_secret_sfdc_api_key              = "${data.aws_secretsmanager_secret_version.sfdc_api_key.secret_id}"
    td_env_secret_sfdc_api_secret           = "${data.aws_secretsmanager_secret_version.sfdc_api_secret.secret_id}"
    td_env_secret_sentry_dsn                = "${data.aws_secretsmanager_secret_version.sentry_dsn.secret_id}"
    td_env_secret_redis_auth_token          = "${data.aws_secretsmanager_secret_version.redis_auth_token.secret_id}"

    # Logs Configuration
    lc_apikey_arn      = "${data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id}"
    lc_options_dd_host = "${var.firelens_options_dd_host}"
    lc_options_dd_tags = "env:${local.env},role:scanner"
    lc_service         = "${var.service}"

    # Firelens Configuration
    cwlogs_region      = "${local.region}"
    cwlogs_name        = "${var.service}-log-group-${local.env}"
    cwlogs_prefix      = "scanner"
    log_container_name = "${var.firelens_container_name}"
    log_image_repo     = "${data.aws_ssm_parameter.fluentbit.value}"
    log_image_version  = "${var.firelens_container_image_version}"
  }
}
