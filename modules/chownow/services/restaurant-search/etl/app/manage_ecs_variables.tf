variable "etl_manage_name" {
  description = "ECS task definition name"
  default     = "restaurant-search-etl-manage"
}

variable "etl_manage_image_uri" {
  description = "ECR image URI"
}

variable "firelens_container_image" {
  description = "firelens container image"
  default     = "public.ecr.aws/aws-observability/aws-for-fluent-bit:2.28.0"
}

variable "td_cpu" {
  description = "allocated vCPU - example: 1024 or '1 vCPU' or '1 vcpu'"
  default     = 1024
}

variable "td_memory" {
  description = "allocated memory - example: 2048 or '2GB' or '2 GB' "
  default     = 2048
}

locals {
  etl_manage_ecs_td = jsonencode(
    [
      {
        essential = true
        image     = var.etl_manage_image_uri
        name      = "${var.etl_manage_name}-${local.env}"
        environment = [
          {
            name  = "ENV"
            value = local.env
          },
          {
            name  = "DD_ENV"
            value = local.env
          },
          {
            name  = "DD_SERVICE"
            value = var.etl_manage_name
          },
          {
            name  = "DD_VERSION"
            value = var.tag_name
          },
          {
            name  = "DD_LOGS_INJECTION"
            value = "true"
          },
          {
            name  = "ES_AWS_ACCESS_KEY_ID_SECRET_ID"
            value = local.es_access_key_id_arn
          },
          {
            name  = "ES_AWS_SECRET_ACCESS_KEY_SECRET_ID"
            value = local.es_secret_access_key_arn
          },
          {
            name  = "MAMMOTH_ES_HOSTS"
            value = local.es_host
          },
          {
            name  = "REPLICA_DB_HOSTNAME"
            value = data.aws_db_instance.replica_db.address
          },
          {
            name  = "REPLICA_DB_USER_SECRET_ID"
            value = data.aws_secretsmanager_secret_version.replica_db_user.secret_id
          },
          {
            name  = "REPLICA_DB_PASS_SECRET_ID"
            value = data.aws_secretsmanager_secret_version.replica_db_password.secret_id
          },
          {
            name  = "REPLICA_DB_NAME"
            value = var.replica_db_name
          },
          {
            name  = "S3_RESTAURANT_MEDIA_BUCKET"
            value = local.s3_restaurant_media_bucket_hostname
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
            value = "${var.service}@${var.tag_name}"
          }
        ]
        command = ["ddtrace-run", "mammoth_etl_manage"]
        logConfiguration = {
          logDriver = "awsfirelens"
          options = {
            Name       = "datadog"
            Host       = "http-intake.logs.datadoghq.com"
            dd_service = var.service
            dd_source  = "fargate"
            dd_tags    = "env:${local.env},service:{var.service},version:${var.tag_name},role:manage"
            TLS        = "on"
            provider   = "ecs"
          }
          secretOptions = [
            {
              name      = "apikey"
              valueFrom = data.aws_secretsmanager_secret_version.dd_api_key.arn
            }
          ]
        }
      },
      {
        essential = true
        image     = var.firelens_container_image
        name      = "log_router"
        firelensConfiguration = {
          type = "fluentbit"
          options = {
            enable-ecs-log-metadata = "true"
            config-file-type        = "file"
            config-file-value       = "/fluent-bit/configs/minimize-log-loss.conf"
          }
        }
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-create-group  = "true"
            awslogs-group         = "${var.service}-logs"
            awslogs-region        = local.aws_region
            awslogs-stream-prefix = "${var.service}-logs-${local.env}"
          }
        }
      },
      {
        essential = true
        name      = "datadog-agent"
        image     = "public.ecr.aws/datadog/agent:latest"
        portMappings = [
          {
            containerPort = 8126
            hostPort      = 8126
            protocol      = "tcp"
          }
        ]
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
            name  = "ECS_ENABLE_CONTAINER_METADATA"
            value = "true"
          },
          {
            name  = "ECS_FARGATE"
            value = "true"
          },
        ]
        logConfiguration = {
          logDriver = "awsfirelens"
          options = {
            Name       = "datadog"
            Host       = "http-intake.logs.datadoghq.com"
            dd_service = var.service
            dd_source  = "fargate"
            dd_tags    = "env:${local.env},service:{var.service},version:${var.tag_name},role:manage"
            TLS        = "on"
            provider   = "ecs"
          }
          secretOptions = [
            {
              name      = "apikey"
              valueFrom = data.aws_secretsmanager_secret_version.dd_api_key.arn
            }
          ]
        }
      }
    ]
  )
}
