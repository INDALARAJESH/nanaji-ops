data "template_file" "web_td" {
  template = file("${path.module}/templates/web_td.json.tpl")

  vars = {
    aws_region            = data.aws_region.current.name
    awslogs_stream_prefix = "${var.service}-${var.web_name}"
    container_port        = var.container_port
    container_port_2      = var.container_port_2
    datadog_env           = local.datadog_env
    ecr_repo_url          = local.ecr_repo_url
    image_tag             = var.image_tag
    env                   = var.env
    name                  = local.web_container_name
    sentry_dsn            = var.sentry_dsn
    image                 = var.image
    efs_container_path    = var.efs_container_path
    service               = var.service
    env                   = var.env
    env_inst              = var.env_inst

    # Logging Configuration
    firelens_dd_host        = var.firelens_options_dd_host
    cwlogs_name             = "${var.service}-${var.web_name}-log-group-${local.env}"
    cwlogs_prefix           = var.web_name
    firelens_container_name = var.firelens_container_name
    fluentbit_image         = data.aws_ssm_parameter.fluentbit_image.value
    dd_ops_api_key          = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
    web_dd_tags             = local.web_dd_tags

    # Secret ARN with password key
    secret_arn = "${data.aws_secretsmanager_secret.appsmith.arn}:APPSMITH_MONGODB_URI::"
  }
}
