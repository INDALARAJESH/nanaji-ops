[
  {
    "essential": true,
    "name": "${web_name}",
    "image": "${web_image_repo}:${web_image_version}",
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
    "portMappings": [
      {
        "containerPort": ${web_container_port}
      }
    ],
    "entrypoint": [],
    "command": ${jsonencode(web_command)},
    "secrets": [
      {
        "name": "SSL_KEY",
        "valueFrom": "${td_env_ssl_key_secret_arn}"
      },
      {
        "name": "SSL_CERT",
        "valueFrom": "${td_env_ssl_cert_secret_arn}"
      }
    ],
    "environment": [
      {
        "name": "ENV",
        "value": "${td_env_env}"
      },
      {
        "name": "DD_SERVICE",
        "value": "${web_name}"
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
        "value": "${web_image_version}"
      },
      {
        "name": "GIT_SHA",
        "value": "${web_image_version}"
      }
    ],
    "dependsOn": [
      { "Condition": "START",
          "ContainerName": "${api_name}"
      }
    ]
  },
  {
    "essential": true,
    "name": "${api_name}",
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
    "portMappings": [
      {
        "containerPort": ${api_container_port}
      }
    ],
    "entrypoint": [],
    "command": ${jsonencode(api_command)},
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
        "value": "${api_name}"
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
        "name": "DD_TRACE_ENABLED",
        "value": "${dd_trace_enabled}"
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
