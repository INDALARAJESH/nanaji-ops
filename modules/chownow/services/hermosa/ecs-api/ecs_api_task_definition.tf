locals {
  web_container = {
    essential = true
    name      = local.web_container_name
    image     = "${var.web_ecr_repository_uri}:${var.web_container_image_version}"
    cpu       = 0 # this doesn't actually get used (Service argument takes priority), but if we dont include it we get a perpetual plan diff
    mountPoints = [
      {
        ContainerPath = "/etc/nginx/ssl"
        ReadOnly      = false
        SourceVolume  = "nginx-config"
      },
      {
        ContainerPath = "/var/cache/nginx"
        ReadOnly      = false
        SourceVolume  = "nginx-cache"
      },
      {
        ContainerPath = "/var/run"
        ReadOnly      = false
        SourceVolume  = "var-run"
      }
    ]
    volumesFrom = local.volumes_from
    linuxParameters = {
      capabilities = {
        add = ["SYS_PTRACE"]
      }
    }
    readonlyRootFilesystem = var.read_only_root_filesystem
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = local.service
        dd_source  = "fargate"
        dd_tags    = local.web_dd_tags
        compress   = "gzip"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    portMappings = [{
      containerPort = tonumber(var.web_container_port)
      hostPort      = tonumber(var.web_container_port)
      protocol      = "tcp"
    }]
    entrypoint  = local.web_entrypoint
    command     = var.web_command
    environment = [for k, v in local.web_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.web_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
    dockerLabels = local.api_docker_labels
    dependsOn : [
      {
        Condition     = "START",
        ContainerName = local.api_container_name
      }
    ]
  }
  web_env = {
    ENV = local.env
    # required for the DD APM agent to pick up these containers
    DD_ENV                   = local.env
    DD_SERVICE               = local.service
    DD_LOGS_INJECTION        = "true"
    DD_VERSION               = local.web_dd_version
    GIT_SHA                  = var.web_container_image_version
    DD_TRACE_ENABLED         = var.dd_trace_enabled
    DD_TAGS                  = local.web_dd_tags
    SYSDIG_ORCHESTRATOR      = local.sysdig_orchestrator_host
    SYSDIG_ORCHESTRATOR_PORT = var.sysdig_orchestrator_port
  }
  web_secrets = [
    { SSL_KEY = var.ssl_key_secret_arn },
    { SSL_CERT = var.ssl_cert_secret_arn }
  ]
  api_container = {
    essential = true
    name      = local.api_container_name
    image     = "${var.api_ecr_repository_uri}:${var.api_container_image_version}"
    cpu       = 0 # this doesn't actually get used (Service argument takes priority), but if we dont include it we get a perpetual plan diff
    mountPoints = [
      {
        ContainerPath = "/opt/chownow/appconfig/local"
        ReadOnly      = false
        SourceVolume  = "hermosa-config"
      },
      {
        ContainerPath = "/var/run"
        ReadOnly      = false
        SourceVolume  = "var-run"
      }
    ]
    volumesFrom = local.volumes_from
    linuxParameters = {
      capabilities = {
        add = ["SYS_PTRACE"]
      }
    }
    readonlyRootFilesystem = var.read_only_root_filesystem
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = local.service
        dd_source  = "fargate"
        dd_tags    = local.api_dd_tags
        compress   = "gzip"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    portMappings = [{
      containerPort = tonumber(var.api_container_port)
      hostPort      = tonumber(var.api_container_port)
      protocol      = "tcp"
    }]
    entrypoint  = local.api_entrypoint
    command     = var.api_command
    environment = [for k, v in local.api_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.api_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
    dockerLabels = local.api_docker_labels
    dependsOn : local.depends_on
  }
  api_env = {
    ENV = local.env
    # required for the DD APM agent to pick up these containers
    DD_ENV                   = local.env
    DD_SERVICE               = local.service
    DD_LOGS_INJECTION        = "true"
    DD_VERSION               = local.api_dd_version
    GIT_SHA                  = var.api_container_image_version
    DD_TRACE_ENABLED         = var.dd_trace_enabled
    DD_TAGS                  = local.api_dd_tags
    SYSDIG_ORCHESTRATOR      = local.sysdig_orchestrator_host
    SYSDIG_ORCHESTRATOR_PORT = var.sysdig_orchestrator_port
  }
  api_secrets = [
    { HERMOSA_CONFIGURATION = var.configuration_secret_arn }
  ]
  api_docker_labels = {
    "com.datadoghq.tags.env" : local.env
    "com.datadoghq.tags.service" : local.service
    "com.datadoghq.tags.deployment_suffix" : var.deployment_suffix
  }
  volumes = [
    {
      name = "nginx-config"
    },
    {
      name = "nginx-cache"
    },
    {
      name = "var-run"
    },
    {
      name = "hermosa-config"
    }
  ]

  ### Hermosa API/Web Service Container Definitions ###
  web_service_container_definitions = [
    local.web_container,
    local.api_container,
    # Shared logging sidecar, with our local config (CloudWatch log group name)
    merge(local.logging_sidecar_fragment,
      {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = module.hermosa_web_service.cloudwatch_log_group_name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "web"
          }
        }
        dockerLabels = local.api_docker_labels
      }
    ),
    # Shared Datadog APM agent, with our local config (application role)
    merge(local.datadog_apm_sidecar_fragment,
      {
        logConfiguration = {
          logDriver = "awsfirelens"
          options = {
            Name       = "datadog"
            Host       = var.firelens_options_dd_host
            TLS        = "on"
            dd_service = local.service
            dd_source  = "fargate"
            dd_tags    = local.api_dd_tags
            provider   = "ecs"
          }
          secretOptions = [
            { name : "apikey", valueFrom : data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id }
          ]
        }
        dockerLabels = local.api_docker_labels
      }
    )
  ]

  volumes_from_default = []

  depends_on_default = [
    {
      Condition     = "START",
      ContainerName = local.datadog_container_name
    }
  ]

  ### Hermosa API/Web Service Container Definitions w/ Sysdig ###
  web_service_container_definitions_sysdig = concat(
    local.web_service_container_definitions,
    [
      # Sysdig agent container
      merge(local.sysdig_agent_container, {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = module.hermosa_web_service.cloudwatch_log_group_name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "web"
          }
        }
      })
    ]
  )

  volumes_from_sysdig = [
    {
      readOnly        = true
      sourceContainer = local.sysdig_container_name
    }
  ]

  depends_on_sysdig = [
    {
      Condition     = "START",
      ContainerName = local.datadog_container_name
    },
    {
      Condition     = "START",
      ContainerName = local.sysdig_container_name
    }
  ]
}
