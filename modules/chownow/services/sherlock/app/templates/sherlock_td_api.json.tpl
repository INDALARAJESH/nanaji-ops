[
  {
    "name": "${name}",
    "image": "${ecr_repo_url}:latest",
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
        "containerPort": ${container_port},
        "hostPort": ${host_port}
      }
    ],
    "entrypoint": [ "${container_entrypoint}" ],
    "command": ["node", "server.js"],
    "environment": [
      {
        "name": "REDIS_HOST",
        "value": "${td_env_redis_host}"
      },
      {
        "name": "REDIS_PORT",
        "value": "${td_env_redis_port}"
      },
      {
        "name": "ENV",
        "value": "${env}"
      },
      {
        "name": "DB_REGION",
        "value": "${aws_region}"
      },
      {
        "name": "DB_TABLE",
        "value": "${td_env_dynamodb_table}"
      },
      {
        "name": "CORS_WHITELIST_URL",
        "value": "${td_env_app_dashboard_url}"
      },
      {
        "name": "DEBUG",
        "value": "winston:*"
      }
    ],
    "secrets" : [
      {
        "name": "REDIS_AUTH_TOKEN",
        "valueFrom": "${td_env_secret_redis_auth_token}"
      },
      {
        "name": "SFDC_USERNAME",
        "valueFrom": "${td_env_secret_sfdc_username}"
      },
      {
        "name": "SFDC_PASSWORD",
        "valueFrom": "${td_env_secret_sfdc_password}"
      },
      {
        "name": "SFDC_INTEGRATION_USER_TOKEN",
        "valueFrom": "${td_env_secret_sfdc_integration_user}"
      },
      {
        "name": "SFDC_PASSWORDTOKEN",
        "valueFrom": "${td_env_secret_sfdc_integration_password}"
      },
      {
        "name": "SFDC_API_KEY",
        "valueFrom": "${td_env_secret_sfdc_api_key}"
      },
      {
        "name": "SFDC_SECRET_KEY",
        "valueFrom": "${td_env_secret_sfdc_api_secret}"
      },
      {
        "name": "SENTRY_DSN",
        "valueFrom": "${td_env_secret_sentry_dsn}"
      }
    ]
  },
  {
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
  }
]
