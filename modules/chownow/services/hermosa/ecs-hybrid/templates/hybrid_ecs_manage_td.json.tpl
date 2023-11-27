[
  {
    "essential": false,
    "name": "data-update",
    "image": "${api_image_repo}:${api_image_version}",
    "logConfiguration": {
      "logDriver": "awsfirelens",
      "options": {
        "Name": "datadog",
        "Host": "${lc_options_dd_host}",
        "TLS": "on",
        "dd_service": "${lc_service}",
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
    },
    "entrypoint": [],
    "command": ${jsonencode(data_update_command)},
    "secrets": [
      {
        "name": "HERMOSA_CONFIGURATION",
        "valueFrom": "${td_env_config_file_secret_arn}"
      }
    ],
    "environment": [
      {
        "name": "ENV",
        "value": "${td_env_env}"
      },
      {
        "name": "DD_SERVICE",
        "value": "hermosa-data-update"
      },
      {
        "name": "DD_ENV",
        "value": "${td_env_env}"
      },
      {
        "name": "DD_LOGS_INJECTION",
        "value": "true"
      },
      {
        "name": "DD_VERSION",
        "value": "${api_image_version}"
      },
      {
        "name": "GIT_SHA",
        "value": "${api_image_version}"
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
        "config-file-value": "/fluent-bit/configs/parse-json.conf"
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
