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
    "entrypoint": [ "/bin/bash", "${container_entrypoint}" ],
    "command": ["ddtrace-run", "uwsgi", "--ini", "/app/etc/uwsgi/uwsgi.ini"],
    "environment": [
      {
        "name": "ENV",
        "value": "${env}"
      },
      {
        "name": "DB_REGION",
        "value": "${aws_region}"
      },
      {
        "name": "LOYALTY_TABLE_NAME",
        "value": "${td_env_dynamodb_table}"
      },
      {
        "name": "SQS_QUEUE_NAME",
        "value": "${td_env_sqs_queue}"
      },
      {
        "name": "DJANGO_SETTINGS_MODULE",
        "value": "app.settings.standard"
      },
      {
        "name": "DD_ENV",
        "value": "${datadog_env}"
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
        "name": "DD_PROFILING_ENABLED",
        "value": "true"
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
        "name": "DD_SERVICE_MAPPING",
        "value": "${td_dd_service_mapping}"
      },
      {
        "name": "GIT_SHA",
        "value": "${image_tag}"
      },
      {
        "name": "LAUNCHDARKLY_ENABLED",
        "value": "${launchdarkly_enabled}"
      },
      {
        "name": "LAUNCHDARKLY_SDK_KEY",
        "value": "${launchdarkly_api_key_arn}"
      },
      {
        "name": "SENTRY_DSN_ARN",
        "value": "${sentry_dsn_arn}"
      },
      {
        "name": "SERVICE_API_KEY_ARN",
        "value": "${service_api_key_arn}"
      }
    ],
    "secrets" : [],
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
