locals {
  manage_container = {
    essential   = true
    name        = local.manage_container_name
    image       = "${var.manage_ecr_repository_uri}:${var.manage_container_image_version}"
    cpu         = 0 # this doesn't actually get used (Service argument takes priority), but if we dont include it we get a perpetual plan diff
    mountPoints = []
    volumesFrom = local.manage_volumes_from
    dependsOn : local.manage_depends_on
    linuxParameters = {
      capabilities = {
        add = ["SYS_PTRACE"]
      }
    }
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = local.service
        dd_source  = "fargate"
        dd_tags    = local.manage_dd_tags
        compress   = "gzip"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    portMappings = []
    entrypoint   = local.manage_entrypoint
    command      = var.manage_command
    environment  = [for k, v in local.manage_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.manage_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
    dockerLabels = local.manage_docker_labels
  }
  manage_env = {
    ENV = local.env
    # required for the DD APM agent to pick up these containers
    DD_ENV                   = local.env
    DD_SERVICE               = local.service
    DD_LOGS_INJECTION        = "true"
    DD_VERSION               = local.manage_dd_version
    GIT_SHA                  = var.manage_container_image_version
    DD_TRACE_ENABLED         = var.dd_trace_enabled
    DD_TAGS                  = local.manage_dd_tags
    SYSDIG_ORCHESTRATOR      = local.sysdig_orchestrator_host
    SYSDIG_ORCHESTRATOR_PORT = var.sysdig_orchestrator_port
  }
  manage_secrets = [
    { HERMOSA_CONFIGURATION = var.configuration_secret_arn }
  ]
  manage_docker_labels = {
    "com.datadoghq.tags.env" : local.env
    "com.datadoghq.tags.service" : local.service
    "com.datadoghq.tags.deployment_suffix" : var.deployment_suffix
  }

  ### Hermosa API/Web Service Container Definitions ###
  manage_task_container_definitions = [
    local.manage_container,
    # shared logging sidecar, with our local config (cloudwatch log group name)
    merge(local.logging_sidecar_fragment, {
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = module.hermosa_web_service.cloudwatch_log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "web"
        }
      }
      dockerLabels = local.manage_docker_labels
    }),

    # shared datadog apm agent, with our local config (application role)
    merge(local.datadog_apm_sidecar_fragment, {
      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          Name       = "datadog"
          Host       = var.firelens_options_dd_host
          TLS        = "on"
          dd_service = local.service
          dd_source  = "fargate"
          dd_tags    = local.manage_dd_tags
          provider   = "ecs"
        }
        secretOptions = [
          { name : "apikey", valueFrom : data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id }
        ]
      }
      dockerLabels = local.manage_docker_labels
    })
  ]

  manage_volumes_from_default = []

  manage_depends_on_default = []

  ### Hermosa API/Web Service Container Definitions w/ Sysdig ###
  manage_task_container_definitions_sysdig = concat(
    local.manage_task_container_definitions,
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

  manage_volumes_from_sysdig = [
    {
      readOnly        = true
      sourceContainer = local.sysdig_container_name
    }
  ]

  manage_depends_on_sysdig = [
    {
      Condition     = "START",
      ContainerName = local.sysdig_container_name
    }
  ]
}
