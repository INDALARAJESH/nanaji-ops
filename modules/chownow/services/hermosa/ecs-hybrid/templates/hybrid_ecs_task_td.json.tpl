[
  {
    "essential": true,
    "name": "${task_name}",
    "image": "${task_image_repo}:${task_image_version}",
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
    "command": ${jsonencode(task_command)},
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
        "value": "${task_name}"
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
        "value": "${task_image_version}"
      },
      {
        "name": "DD_TRACE_ENABLED",
        "value": "${dd_trace_enabled}"
      },
      {
        "name": "GIT_SHA",
        "value": "${task_image_version}"
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
  },
  {
    "name": "datadog-agent",
    "image": "public.ecr.aws/datadog/agent:${dd_agent_container_image_version}",
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
  }
]
