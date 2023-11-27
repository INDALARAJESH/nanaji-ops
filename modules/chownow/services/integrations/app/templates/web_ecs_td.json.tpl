[
  {
    "essential": true,
    "name": "${name}",
    "image": "${image_repo}:${image_version}",
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
    "command": [],
    "environmentFiles": [
      {
        "value": "${td_env_file_path}/web_configs_${env}.env",
        "type": "s3"
      },
      {
        "value": "${td_env_file_path}/web_configs_common.env",
        "type": "s3"
      }
    ],
    "environment": [
      {
        "name": "DD_SERVICE",
        "value": "${lc_service}"
      },
      {
        "name": "DD_ENV",
        "value": "${datadog_env}"
      },
      {
        "name": "DEPLOYMENT_SUFFIX",
        "value": "${deployment_suffix}"
      }
    ],
    "secrets": [
      {
        "name": "EMAIL_HOST_PASSWORD",
        "valueFrom": "${td_env_secret_email_password}"
      },
      {
        "name": "EMAIL_HOST_USER",
        "valueFrom": "${td_env_secret_email_user}"
      },
      {
        "name": "HERMOSA_API_KEY",
        "valueFrom": "${td_env_secret_hermosa_api_key}"
      },
      {
        "name": "NEW_RELIC_LICENSE_KEY",
        "valueFrom": "${td_env_secret_new_relic_license_key}"
      },
      {
        "name": "POSTGRES_PASSWORD",
        "valueFrom": "${td_env_secret_postgres_password}"
      },
      {
        "name": "REDIS_AUTH_TOKEN",
        "valueFrom": "${td_env_secret_redis_auth_token}"
      },
      {
        "name": "SECRET_KEY",
        "valueFrom": "${td_env_secret_secret_key}"
      },
      {
        "name": "SENTRY_DSN",
        "valueFrom": "${td_env_secret_sentry_dsn}"
      },
      {
        "name": "SLACK_MENU_WEBHOOK_URL",
        "valueFrom": "${td_env_secret_slack_menu_webhook}"
      }
    ]
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
    "image": "public.ecr.aws/datadog/agent:latest",
    "cpu": 256,
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
      "valueFrom": "${td_env_secret_datadog_api_key}"
    }],
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
