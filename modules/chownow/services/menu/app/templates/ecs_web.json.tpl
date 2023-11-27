[
  {
    "essential": true,
    "name": "${name}",
    "image": "${image_registry_url}/${image_name}:${image_tag}",
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port}
      }
    ],
    "environment": [
      {
        "name": "ENV",
        "value": "${env}"
      },
      {
        "name": "DATABASE_HOST",
        "value": "${database_host}"
      },
      {
        "name": "READONLY_DB_HOST",
        "value": "${readonly_db_host}"
      },
      {
        "name": "DATABASE_NAME",
        "value": "${database_name}"
      },
      {
        "name": "DATABASE_USER",
        "value": "${database_user}"
      },
      {
        "name": "DATABASE_PORT",
        "value": "${database_port}"
      },
      {
        "name": "DD_ENV",
        "value": "${dd_env}"
      },
      {
        "name": "DD_SERVICE",
        "value": "${dd_service}"
      },
      {
        "name": "DD_VERSION",
        "value": "${image_tag}"
      },
      {
        "name": "DD_TRACE_ENABLED",
        "value": "true"
      },
      {
        "name": "DD_LOGS_INJECTION",
        "value": "true"
      },
      {
        "name": "DD_SERVICE_MAPPING",
        "value": "mysql:menu-mysql,menu-mysql:menu-mysql"
      },
      {
        "name": "DD_TAGS",
        "value": "${lc_options_dd_tags}"
      },
      {
        "name": "IMAGE_NAME",
        "value": "${image_name}:${image_tag}"
      },
      {
        "name": "USE_LAUNCHDARKLY_LIVE_API",
        "value": "true"
      }
    ],
    "secrets": [
      {
        "name": "DATABASE_PASSWORD",
        "valueFrom": "${database_password}"
      },
      {
        "name": "JWT_SECRET",
        "valueFrom": "${jwt_secret}"
      },
      {
        "name": "LAUNCHDARKLY_API_KEY",
        "valueFrom": "${ld_sdk_key}"
      }
    ],
    "dockerLabels": {
      "com.datadoghq.tags.env": "${dd_env}",
      "com.datadoghq.tags.service": "${dd_service}",
      "com.datadoghq.tags.version": "${image_tag}"
    },
    "logConfiguration": {
      "logDriver": "awsfirelens",
      "options": {
        "Name": "datadog",
        "Host": "${lc_options_dd_host}",
        "TLS": "on",
        "dd_service": "${dd_service}",
        "dd_source": "fargate",
        "dd_tags": "${lc_options_dd_tags}",
        "provider": "ecs"
       },
       "secretOptions": [
         {
           "name": "apikey",
           "valueFrom": "${lc_apikey_arn}"
         }
       ]
    }
  },
  {
    "essential": true,
    "name": "datadog-agent",
    "image": "public.ecr.aws/datadog/agent:7",
    "cpu": 256,
    "memory": 256,
    "portMappings": [
      {
        "containerPort": 8126,
        "hostPort": 8126,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "ECS_FARGATE",
        "value": "true"
      },
      {
        "name": "DD_APM_ENABLED",
        "value": "true"
      },
      {
        "name": "DD_APM_NON_LOCAL_TRAFFIC",
        "value": "true"
      },
      {
        "name": "DD_LOG_LEVEL",
        "value": "critical"
      }
    ],
    "secrets": [
      {
        "name": "DD_API_KEY",
        "valueFrom": "${lc_apikey_arn}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awsfirelens",
      "options": {
        "Name": "datadog",
        "Host": "${lc_options_dd_host}",
        "TLS": "on",
        "dd_service": "${dd_service}",
        "dd_source": "fargate",
        "dd_tags": "${lc_options_dd_tags}",
        "compress": "gzip",
        "provider": "ecs"
       },
       "secretOptions": [
         {
           "name": "apikey",
           "valueFrom": "${lc_apikey_arn}"
         }
       ]
    }
  },
  {
    "essential": true,
    "name": "${log_container_name}",
    "image": "${log_image_repo}",
    "firelensConfiguration": {
      "type": "fluentbit",
      "options": {
        "enable-ecs-log-metadata": "true",
        "config-file-type": "file",
        "config-file-value": "/fluent-bit/configs/minimize-log-loss.conf"
      }
    },
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${cwlogs_name}",
        "awslogs-region": "${cwlogs_region}",
        "awslogs-stream-prefix": "${cwlogs_prefix}"
      }
    },
    "memoryReservation": 50
  }
]
