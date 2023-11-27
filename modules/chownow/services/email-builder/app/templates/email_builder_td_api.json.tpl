[
  {
    "essential": true,
    "name": "${name}",
    "image": "${ecr_repo_url}:${image_tag}",
    "logConfiguration": {
      "logDriver": "awsfirelens",
      "options": {
        "Name": "datadog",
        "Host": "${lc_options_dd_host}",
        "TLS": "on",
        "dd_service": "${lc_service}",
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
    },
    "portMappings": [
      {
        "containerPort": ${container_port}
      }
    ],
    "entrypoint": [],
    "environment": [
      {
        "name": "ENVIRONMENT",
        "value": "${env}"
      },
      {
        "name": "PORT",
        "value": "8000"
      },
      {
        "name": "SENTRY_DSN",
        "value": "${sentry_dsn}"
      },
      {
        "name": "DD_ENV",
        "value": "${env}"
      },
      {
        "name": "DD_SERVICE",
        "value": "${lc_service}"
      },
      {
        "name": "DD_LOGS_INJECTION",
        "value": "true"
      },
      {
        "name": "DD_TRACE_ENABLED",
        "value": "true"
      },
      {
        "name": "DD_TRACE_AGENT_PORT",
        "value": "8126"
      },
      {
        "name": "DD_DOGSTATSD_PORT",
        "value": "8125"
      },
      {
        "name": "DD_TRACE_AGENT_HOSTNAME",
        "value": "localhost"
      }
    ],
    "secrets": [
      {
        "name": "GMAIL_USERNAME",
        "valueFrom": "${td_env_secret_gmail_username}"
      },
      {
        "name": "GMAIL_PASSWORD",
        "valueFrom": "${td_env_secret_gmail_password}"
      }
    ],
    "dockerLabels": {
      "com.datadoghq.tags.env": "${env}",
      "com.datadoghq.tags.service": "${lc_service}"
    }
  },
  {
    "essential": true,
    "image": "${log_image_repo}",
    "name": "${log_container_name}",
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
  },
  {
    "name": "datadog-agent",
    "image": "gcr.io/datadoghq/agent:latest",
    "cpu": 10,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "hostPort": 8126,
        "protocol": "tcp",
        "containerPort": 8126
      }
    ],
    "secrets": [{
      "name": "DD_API_KEY",
      "valueFrom": "${lc_apikey_arn}"
    }],
    "environment": [
      {
        "name": "ECS_FARGATE",
        "value": "true"
      },
      {
        "name": "DD_APM_ENABLED",
        "value": "true"
      }
    ],
    "logConfiguration": {
      "logDriver": "awsfirelens",
      "options": {
        "Name": "datadog",
        "Host": "${lc_options_dd_host}",
        "TLS": "on",
        "dd_service": "${lc_service}",
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
  }
]
