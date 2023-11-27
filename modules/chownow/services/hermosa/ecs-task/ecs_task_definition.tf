locals {
  task_container = {
    essential = true
    name      = local.task_container_name
    image     = "${var.task_ecr_repository_uri}:${var.task_container_image_version}"
    cpu       = 0 # this doesn't actually get used (Service argument takes priority), but if we dont include it we get a perpetual plan diff
    mountPoints = [
      {
        ContainerPath = "/opt/chownow/appconfig/local"
        ReadOnly      = false
        SourceVolume  = "hermosa-config"
      },
      {
        ContainerPath = "/var/run/chownow"
        ReadOnly      = false
        SourceVolume  = "hermosa-var-run"
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
        dd_tags    = local.task_dd_tags
        compress   = "gzip"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    portMappings = []
    entrypoint   = local.task_entrypoint
    command      = var.task_command
    environment  = [for k, v in local.task_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.task_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
    dockerLabels = local.docker_labels
    dependsOn : local.depends_on
  }
  task_env = {
    ENV = local.env
    # required for the DD APM agent to pick up these containers
    DD_ENV                   = local.env
    DD_SERVICE               = local.service
    DD_LOGS_INJECTION        = "true"
    DD_VERSION               = local.task_dd_version
    GIT_SHA                  = var.task_container_image_version
    DD_TRACE_ENABLED         = var.dd_trace_enabled
    DD_TAGS                  = local.task_dd_tags
    SYSDIG_ORCHESTRATOR      = local.sysdig_orchestrator_host
    SYSDIG_ORCHESTRATOR_PORT = var.sysdig_orchestrator_port
    CN_MYSQL_TXN_ISO_LEVEL   = "READ_COMMITTED"
  }
  task_secrets = [
    { HERMOSA_CONFIGURATION = var.configuration_secret_arn }
  ]
  volumes = [
    {
      name = "hermosa-config"
    },
    {
      name = "hermosa-var-run"
    }
  ]

  ### Hermosa Task Service Container Definitions ###
  task_service_container_definitions = [
    local.task_container,
    # Shared logging sidecar, with our local config (CloudWatch log group name)
    merge(local.logging_sidecar_fragment,
      {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = module.ecs_service_task.cloudwatch_log_group_name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "task"
          }
        }
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
            dd_tags    = local.task_dd_tags
            provider   = "ecs"
          }
          secretOptions = [
            { name : "apikey", valueFrom : data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id }
          ]
        }
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

  ### Hermosa Task Service Container Definitions w/ Sysdig ###
  task_service_container_definitions_sysdig = concat(
    local.task_service_container_definitions,
    [
      # Sysdig agent container
      merge(local.sysdig_agent_container,
        {
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = module.ecs_service_task.cloudwatch_log_group_name
              awslogs-region        = data.aws_region.current.name
              awslogs-stream-prefix = "task"
            }
          }
        }
      )
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
