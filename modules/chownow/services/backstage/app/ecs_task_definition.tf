locals {
  datadog_container_name = "datadog-agent"
  dd_tags                = "env:${local.env},version:${var.image_tag},cn_namespace:${var.service}"
  container = {
    essential = true
    name      = var.service
    image     = "${var.image_repo}:${var.image_tag}"
    cpu       = 0 # this doesn't actually get used (Service argument takes priority), but if we dont include it we get a perpetual plan diff
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = var.service
        dd_source  = "fargate"
        dd_tags    = local.dd_tags
        compress   = "gzip"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    portMappings = [{
      containerPort = tonumber(var.container_port)
      hostPort      = tonumber(var.container_port)
      protocol      = "tcp"
    }]
    entrypoint = null
    command = [
      "node",
      "packages/backend",
      "--use-openssl-ca",
      "--config",
      "app-config.yaml",
      "--config",
      "app-config.dev.yaml"
    ]
    environment = [for k, v in local.container_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.container_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
    dependsOn : local.depends_on
  }
  container_env = {
    ENV           = local.env
    POSTGRES_HOST = data.aws_db_instance.database.address
    POSTGRES_USER = "postgres"
    # required for the DD APM agent to pick up these containers
    DD_ENV            = local.env
    DD_SERVICE        = var.service
    DD_LOGS_INJECTION = "true"
    DD_VERSION        = var.image_tag
    GIT_SHA           = var.image_tag
    DD_TRACE_ENABLED  = var.dd_trace_enabled
    DD_TAGS           = local.dd_tags
  }
  container_secrets = [
    { GITHUB_CLIENT_ID = data.aws_secretsmanager_secret.github_client_id.arn },
    { GITHUB_CLIENT_SECRET = data.aws_secretsmanager_secret.github_client_secret.arn },
    { POSTGRES_PASSWORD = data.aws_secretsmanager_secret.database_password.arn },
    { GITHUB_APP_ID = "${data.aws_secretsmanager_secret.github_catalog_integration_secret.arn}:app_id::" },
    { GITHUB_APP_CLIENT_ID = "${data.aws_secretsmanager_secret.github_catalog_integration_secret.arn}:client_id::" },
    { GITHUB_APP_CLIENT_SECRET = "${data.aws_secretsmanager_secret.github_catalog_integration_secret.arn}:client_secret::" },
    { GITHUB_APP_WEBHOOK_SECRET = "${data.aws_secretsmanager_secret.github_catalog_integration_secret.arn}:webhook_secret::" },
    { GITHUB_APP_PRIVATE_KEY = "${data.aws_secretsmanager_secret.github_catalog_integration_secret.arn}:private_key::" },
  ]
  container_definitions = [
    local.container,
    # Shared logging sidecar, with our local config (CloudWatch log group name)
    merge(local.logging_sidecar_fragment,
      {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = module.ecs.cloudwatch_log_group_name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "web"
          }
        }
      }
    ),
    # Shared Datadog APM agent, with our local config (application role)
    merge(local.datadog_apm_sidecar_fragment,
      {
        logConfiguration = {
          logDriver = "awsfirelens"
          options = {
            Name       = "datadog"
            Host       = var.firelens_options_dd_host
            TLS        = "on"
            dd_service = var.service
            dd_source  = "fargate"
            dd_tags    = local.dd_tags
            provider   = "ecs"
          }
          secretOptions = [
            { name : "apikey", valueFrom : data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id }
          ]
        }
      }
    )
  ]
  depends_on = [
    {
      Condition     = "START",
      ContainerName = local.datadog_container_name
    }
  ]
}
