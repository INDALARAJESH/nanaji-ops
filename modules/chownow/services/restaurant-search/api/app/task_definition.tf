locals {
  td_api = {
    name  = local.container_name
    image = "${var.docker_image_uri}:${var.api_source_code_version}"
    command = [
      "ddtrace-run",
      "uvicorn",
      "mammoth_fastapi.main:app",
      "--host",
      "0.0.0.0",
      "--port",
      tostring(local.container_port),
      "--workers",
      var.api_wsgi_workers
    ]
    essential = false
    dockerLabels = {
      "com.datadoghq.ad.instances"    = "[{\"host\": \"%%host%%\", \"port\": ${local.container_port}}]"
      "com.datadoghq.ad.check_names"  = "[\"ecs_fargate\"]"
      "com.datadoghq.ad.init_configs" = "[{}]"
      "com.datadoghq.tags.env"        = local.env
      "com.datadoghq.tags.service"    = var.service
      "com.datadoghq.tags.version"    = var.api_source_code_version
    }
    # the underlying ecs service uses awsvpc networking
    # containerPort and hostPort must match
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = local.container_port
        hostPort      = local.container_port
      }
    ]
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        dd_message_key = "message"
        provider       = "ecs"
        dd_service     = var.service
        dd_source      = "fastapi"
        Host           = "http-intake.logs.datadoghq.com"
        TLS            = "on"
        dd_tags        = "env:${local.env},service:${var.service}-${local.service_role},version:${local.container_name}.${var.api_source_code_version}"
        Name           = "datadog"
      }
      secretOptions = [
        {
          name      = "apikey"
          valueFrom = data.aws_secretsmanager_secret_version.dd_api_key.arn
        }
      ]
    }
    secrets = [
      {
        name      = "AWS_ACCESS_KEY_ID"
        valueFrom = data.aws_secretsmanager_secret_version.es_access_key_id.arn
      },
      {
        name      = "AWS_SECRET_ACCESS_KEY"
        valueFrom = data.aws_secretsmanager_secret_version.es_secret_access_key.arn
      },
      {
        name      = "CN_LAUNCHDARKLY_API_KEY"
        valueFrom = data.aws_secretsmanager_secret_version.ld_api_key.arn
      },
      {
        name      = "HERMOSA_LAUNCHDARKLY_SDK_KEY"
        valueFrom = data.aws_secretsmanager_secret_version.hermosa_ld_sdk_key.arn
      }
    ]
    environment = [
      {
        name  = "SOURCE_CODE_VERSION"
        value = var.api_source_code_version
      },
      {
        name  = "MAMMOTH_ES_HOSTS"
        value = "https://${data.aws_elasticsearch_domain.restaurant_search.endpoint}"
      },
      {
        name  = "ELASTICSEARCH_USE_AUTH"
        value = "true"
      },
      {
        name  = "DD_ENV"
        value = local.env
      },
      {
        name  = "DD_SERVICE"
        value = "${var.service}-${local.service_role}"
      },
      {
        name  = "DD_SOURCE"
        value = "fastapi"
      },
      {
        name  = "DD_LOGS_INJECTION"
        value = "true"
      },
      {
        name  = "DD_PROFILING_ENABLED"
        value = "true"
      },
      {
        name  = "DD_VERSION"
        value = "${local.container_name}.${var.api_source_code_version}"
      },
      {
        name  = "SENTRY_DSN"
        value = var.sentry_dsn
      },
      {
        name  = "SENTRY_ENVIRONMENT"
        value = local.env
      },
      {
        name  = "SENTRY_RELEASE"
        value = "${var.service}-api@${var.api_source_code_version}"
      },
      {
        name  = "LOG_JSON"
        value = "true"
      },
      {
        name  = "ENV",
        value = local.env
      }
    ]
  }

  td_dd_logs = {
    name             = "log_router"
    image            = "public.ecr.aws/aws-observability/aws-for-fluent-bit:stable"
    logConfiguration = null
    user             = "0"

    firelensConfiguration = {
      type = "fluentbit"
      options = {
        enable-ecs-log-metadata = "true"
        config-file-type        = "file"
        config-file-value       = "/fluent-bit/configs/parse-json.conf"
      }
    }

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = "${var.service}-logs-${local.env}"
        awslogs-group         = "${var.service}-logs"
        awslogs-create-group  = "true"
      }
    }
  }

  td_dd_metrics = {
    name   = "datadog-agent"
    image  = "public.ecr.aws/datadog/agent:latest"
    cpu    = 256
    memory = 256
    secrets = [
      {
        name      = "DD_API_KEY"
        valueFrom = data.aws_secretsmanager_secret_version.dd_api_key.arn
      }
    ]
    environment = [
      {
        name  = "DD_APM_ENABLED"
        value = "true"
      },
      {
        name  = "DD_APM_NON_LOCAL_TRAFFIC"
        value = "true"
      },
      {
        name  = "ECS_FARGATE",
        value = "true"
      },
      {
        name  = "ECS_ENABLE_CONTAINER_METADATA",
        value = "true"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = "${var.service}-logs-${local.env}"
        awslogs-group         = "${var.service}-logs"
        awslogs-create-group  = "true"
      }
    }
  }

  td_full = jsonencode([
    local.td_api,
    local.td_dd_logs,
    local.td_dd_metrics
  ])
}
