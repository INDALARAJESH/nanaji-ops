locals {
  td_container_definitions = jsonencode(
    [
      {
        command = ["errbot"]
        cpu     = 0
        dependsOn = [
          {
            Condition     = "START"
            ContainerName = "sysdig-agent"
          }
        ]
        entrypoint = ["/opt/draios/bin/instrument"]
        environment = [
          {
            name  = "JENKINS_URL"
            value = "http://jankyns0.ops.aws.chownow.com:8080"
          },
          {
            name  = "JENKINS_USERNAME"
            value = "ops-service@chownow.com"
          },
          {
            name  = "ENV"
            value = local.env
          },
          {
            name  = "SYSDIG_ORCHESTRATOR"
            value = "sysdig-fargate-orchestrator-nlb.${local.env}.aws.chownow.com"
          },
          {
            name  = "SYSDIG_ENABLE_LOG_FORWARD"
            value = "false"
          },
          {
            name  = "SYSDIG_LOGGING"
            value = "warning"
          },
        ]
        essential = true
        image     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/ops-serverless-errbot:${var.image_version}"
        linuxParameters = {
          capabilities = {
            add = ["SYS_PTRACE"]
          }
        }
        logConfiguration = {
          logDriver = "awsfirelens"
          options = {
            Host       = "http-intake.logs.datadoghq.com"
            Name       = "datadog"
            TLS        = "on"
            dd_service = var.service
            dd_source  = "fargate"
            dd_tags    = "env:${local.env},role:service"
            provider   = "ecs"
          }
          secretOptions = [
            {
              name      = "apikey"
              valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
            },
          ]
        }
        mountPoints  = []
        name         = "${var.service}-${local.env}"
        portMappings = []
        secrets = [
          {
            name      = "BOT_IDENTITY"
            valueFrom = data.aws_secretsmanager_secret_version.slack_bot_token.secret_id
          },
          {
            name      = "BOT_APP_TOKEN"
            valueFrom = data.aws_secretsmanager_secret_version.slack_app_token.secret_id
          },
          {
            name      = "BOT_SIGNING_SECRET"
            valueFrom = data.aws_secretsmanager_secret_version.slack_signing_secret.secret_id
          },
          {
            name      = "JENKINS_PASSWORD"
            valueFrom = data.aws_secretsmanager_secret_version.jenkins_password.secret_id
          },
          {
            name      = "BOT_ADMINS"
            valueFrom = data.aws_secretsmanager_secret_version.bot_admins.secret_id
          },
        ]
        volumesFrom = [
          {
            readOnly        = true
            sourceContainer = "sysdig-agent"
          }
        ]
      },
      #fluent-bit container for logging
      {
        cpu         = 0
        environment = []
        essential   = true
        firelensConfiguration = {
          options = {
            config-file-type        = "file"
            config-file-value       = "/fluent-bit/configs/minimize-log-loss.conf"
            enable-ecs-log-metadata = "true"
          }
          type = "fluentbit"
        }
        image = data.aws_ssm_parameter.fluentbit.value
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "${var.service}-log-group-${local.env}"
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "service"
          }
        }
        memoryReservation = 50
        mountPoints       = []
        name              = "log_router"
        portMappings      = []
        user              = "0"
        volumesFrom       = []
      },
      {
        cpu         = 0
        environment = []
        essential   = true
        image       = "quay.io/sysdig/workload-agent:latest"
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "${var.service}-log-group-${local.env}"
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "sysdig-agent"
          }
        }
        memory       = 256
        mountPoints  = []
        name         = "sysdig-agent"
        portMappings = []
        user         = "0"
        volumesFrom  = []
      }
  ])
}
