data "template_file" "full_td" {
  template = file("${path.module}/templates/full_ecs_td.json.tpl")

  vars = {
    web_name                    = local.web_container_name
    web_image_repo              = var.web_ecr_repository_uri
    web_image_version           = var.web_container_image_version
    web_container_port          = var.web_container_port
    api_name                    = local.api_container_name
    api_image_repo              = var.api_ecr_repository_uri
    api_image_version           = var.api_container_image_version
    api_container_port          = var.api_container_port
    task_name                   = local.task_container_name
    task_image_repo             = var.task_ecr_repository_uri
    task_image_version          = var.task_container_image_version
    mysql_image_repo            = var.mysql_ecr_repository_uri
    mysql_image_version         = var.mysql_container_image_version
    redis_image_repo            = var.redis_ecr_repository_uri
    redis_image_version         = var.redis_container_image_version
    elasticsearch_image_repo    = var.elasticsearch_ecr_repository_uri
    elasticsearch_image_version = var.elasticsearch_container_image_version
    config_image_repo           = var.config_ecr_repository_uri
    config_image_version        = var.config_container_image_version

    # firelens
    cwlogs_region      = local.region
    cwlogs_name        = module.hermosa_web_service.cloudwatch_log_group_name
    cwlogs_prefix      = "web"
    log_container_name = var.firelens_container_name
    log_image_repo     = data.aws_ssm_parameter.fluentbit.value
    log_image_version  = var.firelens_container_image_version

    # logConfiguration
    lc_apikey_arn      = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = "env:${local.env}"
    lc_service         = local.service

    # datadog agent
    dd_agent_container_image_version = var.dd_agent_container_image_version

    # environment
    td_env_env = local.env

    # secrets
    td_env_ssl_key_secret_arn     = data.aws_secretsmanager_secret_version.ssl_key.secret_id
    td_env_ssl_cert_secret_arn    = data.aws_secretsmanager_secret_version.ssl_cert.secret_id
    td_env_config_file_secret_arn = data.aws_secretsmanager_secret_version.configuration.secret_id

  }
}
