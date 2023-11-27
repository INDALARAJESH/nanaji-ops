[
  {
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
    "entrypoint": [],
    "command": [],
    "environmentFiles": [
      {
        "value": "${td_env_file_path}/manage_configs_${env}.env",
        "type": "s3"
      },
      {
        "value": "${td_env_file_path}/manage_configs_common.env",
        "type": "s3"
      }
    ],
    "environment": [
      {
        "name": "DEPLOYMENT_SUFFIX",
        "value": "${deployment_suffix}"
      },
      {
        "name": "HERMOSA_API_URL",
        "value": "${hermosa_api_url}"
      }
    ],
    "secrets" : [
      {
        "name": "HERMOSA_API_KEY",
        "valueFrom": "${td_env_secret_hermosa_api_key}"
      },
      {
        "name": "REDIS_AUTH_TOKEN",
        "valueFrom": "${td_env_secret_redis_auth_token}"
      },
      {
        "name": "PGMASTER_PASSWORD",
        "valueFrom": "${td_env_secret_pgmaster_password}"
      },
      {
        "name": "POSTGRES_PASSWORD",
        "valueFrom": "${td_env_secret_postgres_password}"
      },
      {
        "name": "SECRET_KEY",
        "valueFrom": "${td_env_secret_secret_key}"
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
    }
  }
]
