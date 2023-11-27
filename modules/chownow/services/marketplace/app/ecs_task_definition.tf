locals {
  ### Fully combined task definition
  marketplace_container_definitions = jsonencode(
    [
      local.marketplace_container,
      local.log_router_container,
      local.datadog_agent_container
    ]
  )
  ### Task definition fragment - Marketplace container
  marketplace_container = {
    name  = local.marketplace_container_name
    image = "${local.marketplace_ecr_repo}:${var.image_tag}"
    cpu   = 0 # This is included to avoid a perpetual TF plan diff
    portMappings = [
      {
        containerPort = tonumber(var.marketplace_container_port)
        hostPort      = tonumber(var.marketplace_container_port)
        protocol      = "tcp"
      }
    ]
    essential   = true
    entryPoint  = local.marketplace_entrypoint
    command     = var.marketplace_command
    environment = [for k, v in local.marketplace_env : { name : tostring(k), value : tostring(v) }]
    mountPoints = []
    volumesFrom = []
    linuxParameters = {
      capabilities = {
        add = ["SYS_PTRACE"]
      }
    }
    dockerLabels = {
      "com.datadoghq.tags.env" : local.env
      "com.datadoghq.tags.service" : var.service
    }
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = var.service
        dd_source  = "fargate"
        dd_tags    = "env:${local.env},role:service"
        provider   = "ecs"
      }
      secretOptions = [
        {
          name      = "apikey"
          valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
        }
      ]
    }
  }
  ### Marketplace container environment variables
  marketplace_env = {
    ENVIRONMENT                        = var.env
    PORT                               = var.marketplace_container_port
    SENTRY_DSN                         = var.sentry_dsn
    DD_ENV                             = var.env
    DD_SERVICE                         = var.service
    DD_LOGS_INJECTION                  = true
    DD_TRACE_ENABLED                   = true
    DD_TRACE_AGENT_PORT                = 8126
    DD_DOGSTATSD_PORT                  = 8125
    DD_TRACE_AGENT_HOSTNAME            = "localhost"
    NEXT_PUBLIC_API_HOST               = local.api_host
    NEXT_PUBLIC_LAUNCH_DARKLY_ID       = var.launch_darkly_id
    NEXT_PUBLIC_GOOGLE_MAPS_CLIENT_KEY = var.google_maps_client_key
    NEXT_PUBLIC_GOOGLE_OAUTH_CLIENT_ID = var.google_oauth_client_id
    NEXT_PUBLIC_GOOGLE_ANALYTICS_ID    = var.google_analytics_id
    NEXT_PUBLIC_FACEBOOK_OUATH_APP_ID  = var.facebook_oauth_app_id
    NEXT_PUBLIC_SENTRY_AUTH_TOKEN      = var.sentry_auth_token
    NEXT_PUBLIC_BRANCH_IO_KEY          = var.branch_io_key
    NEXT_PUBLIC_DEPLOY_ENV             = local.env
    NODE_ENV                           = "production"
    SYSDIG_ORCHESTRATOR                = local.sysdig_orchestrator
    SYSDIG_ORCHESTRATOR_PORT           = var.sysdig_orchestrator_port
    SYSDIG_LOGGING                     = "warning"
    SYSDIG_ENABLE_LOG_FORWARD          = "false"
  }
  ### Task definition fragment - Log router container
  log_router_container = {
    name              = var.firelens_container_name
    image             = data.aws_ssm_parameter.fluentbit.value
    cpu               = 0
    memoryReservation = 50
    portMappings      = []
    essential         = true
    environment       = []
    mountPoints       = []
    volumesFrom       = []
    user              = "0"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "${var.service}-service-log-group-${local.env}"
        awslogs-region        = local.region
        awslogs-stream-prefix = "service"
      }
    }
    firelensConfiguration = {
      type = "fluentbit"
      options = {
        enable-ecs-log-metadata = "true"
        config-file-type        = "file"
        config-file-value       = "/fluent-bit/configs/parse-json.conf"
      }
    }
  }
  ### Task definition fragment - Datadog agent container
  datadog_agent_container = {
    name   = local.datadog_container_name
    image  = "public.ecr.aws/datadog/agent:${var.dd_agent_container_image_version}"
    cpu    = 0
    memory = 256
    portMappings = [
      {
        containerPort = 8126
        hostPort      = 8126
        protocol      = "tcp"
      }
    ]
    essential = true
    environment = [for name, value in {
      ECS_FARGATE    = "true"
      DD_APM_ENABLED = "true"
      } : { name : name, value : value }
    ]
    mountPoints = []
    volumesFrom = []
    secrets = [for name, valueFrom in {
      DD_API_KEY = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      } : { name : name, valueFrom : valueFrom }
    ]
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
        {
          name : "apikey"
          valueFrom : data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
        }
      ]
    }

  }
}
