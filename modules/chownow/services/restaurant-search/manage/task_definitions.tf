module "ecs_task_definition" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.2"

  ecs_execution_iam_policy = data.aws_iam_policy_document.restaurant_search_ecs_execution.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.restaurant_search_ecs_task.json
  env                      = var.env
  env_inst                 = var.env_inst
  service                  = var.service
  service_role             = local.service_role
  td_container_definitions = local.td_full
}

locals {
  td_manage = {
    name      = local.container_name
    image     = "${var.docker_image_uri}:${var.api_source_code_version}"
    command   = ["ddtrace-run", "mammoth_elasticdsl", "migrate"]
    essential = true
    dockerLabels = {
      "com.datadoghq.ad.check_names"  = "[\"ecs_fargate\"]"
      "com.datadoghq.ad.init_configs" = "[{}]"
      "com.datadoghq.tags.env"        = local.env
      "com.datadoghq.tags.service"    = var.service
      "com.datadoghq.tags.version"    = var.api_source_code_version
    }
    # the underlying ecs service uses awsvpc networking
    # containerPort and hostPort must match
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        dd_message_key = "message"
        provider       = "ecs"
        dd_service     = var.service
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
        value = "${var.service}-${local.env}@${var.api_source_code_version}"
      },
      {
        name  = "REPLICA_DB_NAME"
        value = var.replica_db_name
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
    name  = "datadog-agent"
    image = "public.ecr.aws/datadog/agent:latest"
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
    local.td_manage,
    local.td_dd_logs,
    local.td_dd_metrics
  ])
}
