[
  {
    "essential": true,
    "name": "${name}",
    "image": "${ecr_repo_url}:${image_tag}",
    "cpu": 2048,
    "memory": 4096,
    "mountPoints": [
      {
        "containerPath": "${efs_container_path}",
        "sourceVolume": "efs"
      }
    ],
    "logConfiguration": {
      "logDriver": "awsfirelens",
      "options": {
        "Host": "${firelens_dd_host}",
        "Name": "datadog",
        "TLS": "on",
        "compress": "gzip",
        "dd_service": "appsmith-web",
        "dd_source": "fargate",
        "dd_tags": "${web_dd_tags}",
        "provider": "ecs"
      },
      "secretOptions": [
        {
          "name": "apikey",
          "valueFrom": "${dd_ops_api_key}"
        }
      ]
    },
    "secrets": [
      {
        "name": "APPSMITH_MONGODB_URI",
        "valueFrom": "${secret_arn}"
      }
    ],
    "portMappings": [
      {
        "containerPort": ${container_port_2}
      }
    ],
    "environment": [
      {
        "name": "APPSMITH_ADMIN_EMAILS",
        "value": "haleigh.westwood@chownow.com,itserviceaccount@chownow.com, eric.tew@chownow.com, allen.dantes@chownow.com, jobin.muthalaly@chownow.com, joe.perez@chownow.com"
      },
      {
        "name": "APPSMITH_SIGNUP_DISABLED",
        "value": "true"
      },
      {
        "name": "APPSMITH_SIGNUP_ALLOWED_DOMAINS",
        "value": "chownow.com"
      },
      {
        "name": "SYSDIG_ORCHESTRATOR",
        "value": "sysdig-fargate-orchestrator-nlb.${env}.aws.chownow.com"
      },
      {
        "name": "SYSDIG_ORCHESTRATOR_PORT",
        "value": "6667"
      },
      {
        "name": "SYSDIG_ENABLE_LOG_FORWARD",
        "value": "false"
      },
      {
        "name": "SYSDIG_LOGGING",
        "value": "warning"
      }
    ],
    "entryPoint": [
      "/opt/draios/bin/instrument"
    ],
    "command": [
      "/bin/sh",
      "entrypoint.sh"
    ],
    
    "linuxParameters": {
      "capabilities": {
        "add": [
          "SYS_PTRACE"
        ]
      }
    },
    "volumesFrom": [
      {
        "sourceContainer": "sysdig-agent",
        "readOnly": true
      }
    ]
  },
  {
    "essential": true,
    "name": "${firelens_container_name}",
    "image": "${fluentbit_image}",
    "cpu": 0,
    "memoryReservation": 50,
    "mountPoints": [],
    "user": "0",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${service}-web-log-group-${env}${env_inst}",
        "awslogs-region": "us-east-1",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "web"
      }
    },
    "firelensConfiguration": {
      "type": "fluentbit",
      "options": {
        "config-file-type": "file",
        "config-file-value": "/fluent-bit/configs/parse-json.conf",
        "enable-ecs-log-metadata": "true"
      }
    }
  },
  {
    "cpu": 0,
    "environment": [],
    "essential": true,
    "image": "quay.io/sysdig/workload-agent:latest",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${service}-log-group-${env}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "sysdig-agent"
      }
    },
    "memory": 256,
    "mountPoints": [],
    "name": "sysdig-agent",
    "portMappings": [],
    "user": "0",
    "volumesFrom": []
  }
]