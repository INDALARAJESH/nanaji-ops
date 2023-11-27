locals {
  datadog_apm_sidecar_fragment = {
    essential   = true
    name        = local.datadog_container_name
    image       = "public.ecr.aws/datadog/agent:${var.dd_agent_container_image_version}"
    cpu         = 0
    memory      = 256
    mountPoints = []
    volumesFrom = []
    portMappings = [
      #https://docs.datadoghq.com/containers/amazon_ecs/apm/?tabs=ec2metadataendpoint
      { hostPort = 8126, protocol = "tcp", containerPort = 8126 }
    ]
    secrets = [for name, valueFrom in {
      DD_API_KEY = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      } : { name : name, valueFrom : valueFrom }
    ]
    environment = [for name, value in {
      ECS_FARGATE              = "true"
      DD_APM_ENABLED           = "true"
      DD_APM_NON_LOCAL_TRAFFIC = "true"
      } : { name : name, value : value }
    ]
    dockerLabels = local.docker_labels
  }

  # the logging sidecar is shared and gets used by many task definitions
  # since a nested tag varies, merge it with a consumer-local structure to complete
  logging_sidecar_fragment = {
    essential         = true
    name              = var.firelens_container_name
    image             = data.aws_ssm_parameter.fluentbit.value
    cpu               = 0
    environment       = []
    memoryReservation = 50
    mountPoints       = []
    portMappings      = []
    user              = "0"
    volumesFrom       = []
    firelensConfiguration = {
      type = "fluentbit"
      options = {
        enable-ecs-log-metadata = "true"
        config-file-type        = "file"
        config-file-value       = "/fluent-bit/configs/parse-json.conf"
      }
    }
    dockerLabels = local.docker_labels
  }

  docker_labels = {
    "com.datadoghq.tags.env" : local.env
    "com.datadoghq.tags.service" : local.service
    "com.datadoghq.tags.deployment_suffix" : var.deployment_suffix
  }

  sysdig_agent_container = {
    essential   = true
    name        = local.sysdig_container_name
    image       = "quay.io/sysdig/workload-agent:${var.sysdig_agent_container_image_version}"
    cpu         = 0
    memory      = 256
    mountPoints = []
    volumesFrom = []
    environment = [for k, v in local.sysdig_env : { name : tostring(k), value : tostring(v) }]
  }
  sysdig_env = {
    ENV                      = local.env
    SYSDIG_ORCHESTRATOR      = local.sysdig_orchestrator_host
    SYSDIG_ORCHESTRATOR_PORT = var.sysdig_orchestrator_port
    SYSDIG_LOGGING           = "debug"
  }
}
