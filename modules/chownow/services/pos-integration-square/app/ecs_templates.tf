
data "template_file" "ecs_td_manage" {
  template = file("${path.module}/templates/ecs_task_manage.json")

  vars = {
    aws_region            = data.aws_region.current.name
    awslogs_stream_prefix = format("%s-manage", local.app_name)
    container_command     = "'print(1234567890)'"
    container_image_uri   = var.image_uri
    env                   = local.env
    log_group             = format("%s-ecs-task-manage-%s", local.app_name, local.env)
    name                  = format("%s-manage-%s", local.app_name, local.env)

    # firelens
    cwlogs_region      = data.aws_region.current.name
    cwlogs_name        = format("%s-ecs-task-manage-%s", local.app_name, local.env)
    cwlogs_prefix      = "manage"
    log_container_name = var.firelens_container_name
    log_image_repo     = "906394416424.dkr.ecr.us-east-1.amazonaws.com/aws-for-fluent-bit:2.23.3"
    log_image_version  = var.firelens_container_image_version

    # log configuration
    lc_apikey_arn      = data.aws_secretsmanager_secret.dd_api_key.arn
    lc_options_dd_host = var.firelens_options_dd_host
    lc_options_dd_tags = format("env:%s,role:manage", local.env)
    lc_service         = local.service

    # environment variables
    LOGGER_LOG_EVENT = var.logger_log_event # can reveal sensitive info in logs / datadog
    DEBUG            = var.debug
    LOG_LEVEL        = var.log_level
    ENV              = local.env

    DB_DETAILS_ARN_SECRET_KEY                       = data.aws_secretsmanager_secret.secrets["rds_db_details"].arn
    HMAC_SIGNATURE_KEY_ARN_SECRET_KEY               = data.aws_secretsmanager_secret.secrets["hmac_signature_key"].arn
    REDIS_CACHE_PASSWORD_ARN_SECRET_KEY             = data.aws_secretsmanager_secret.secrets["redis_auth_token"].arn
    REDIS_CACHE_HOST                                = data.aws_elasticache_replication_group.redis.primary_endpoint_address
    REDIS_CACHE_SSL                                 = var.redis_cache_ssl
    KMS_ARN_AND_KEY_ID                              = data.aws_kms_key.pos_square.arn
    MOCKED_POS_VENDOR_API                           = var.mocked_pos_vendor_api
    POS_VENDOR_IS_SANDBOX                           = var.pos_vendor_is_sandbox
    POS_VENDOR_API_URL                              = var.pos_vendor_api_url
    POS_VENDOR_OAUTH_CLIENT_ID                      = var.pos_vendor_oauth_client_id
    POS_VENDOR_OAUTH_CLIENT_SECRET_ARN_SECRET_KEY   = data.aws_secretsmanager_secret.secrets["pos_square_oauth_client_secret"].arn
    SENTRY_URL_ARN_SECRET_KEY                       = data.aws_secretsmanager_secret.secrets["sentry_url"].arn
    SF_API_PASSWORD_ARN_SECRET_KEY                  = data.aws_secretsmanager_secret.secrets["sf_api_password"].arn
    SF_API_SECURITY_TOKEN_ARN_SECRET_KEY            = data.aws_secretsmanager_secret.secrets["sf_api_security_token"].arn
    POS_VENDOR_WEBHOOK_SIGNATURE_KEY_ARN_SECRET_KEY = data.aws_secretsmanager_secret.secrets["pos_vendor_webhook_signature_key"].arn
    SF_API_IS_SANDBOX                               = var.sf_api_is_sandbox
    SF_API_USERNAME                                 = var.sf_api_username
    HERMOSA_DASHBOARD_URL                           = local.hermosa_dashboard_url
    STEAKS_WEBHOOK_URL_ARN_SECRET_KEY               = data.aws_secretsmanager_secret.secrets["steaks_webhook_url"].arn
    METRICS_IS_ENABLED                              = var.metrics_is_enabled
    METRICS_SERVICE_NAME                            = var.metrics_service_name
  }
}
