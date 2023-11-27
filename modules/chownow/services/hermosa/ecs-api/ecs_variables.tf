variable "wait_for_steady_state" {
  description = "wait for deployment to be ready"
  default     = true
}

## secrets
variable "configuration_secret_arn" {
  description = "configuration secret arn"
}

variable "ssl_key_secret_arn" {
  description = "ssl_key secret arn"
}

variable "ssl_cert_secret_arn" {
  description = "ssl_cert secret arn"
}

## task definition vars

// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
variable "task_cpu" {
  description = "minimum cpu required for the task to be scheduled"
  default     = 2048
}

// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
variable "task_memory" {
  description = "minimum memory required for the task to be scheduled"
  default     = 4096
}

## api container vars
variable "api_container_image_version" {
  description = "the api container image version"
  default     = "api-latest"
}

variable "api_ecr_repository_uri" {
  description = "ECR repository uri for the api container"
  default     = ""
}

variable "api_container_port" {
  description = "api container ingress TCP port"
  default     = "1180"
}

variable "api_command" {
  description = "api container command"
  default     = ["/bin/bash", "/opt/chownow/ecs/start_hermosa_api.sh"]
}

## web container vars
variable "web_container_deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds"
  default     = 5
}

variable "web_container_image_version" {
  description = "the image version used to start the web container"
  default     = "web-latest"
}

variable "web_container_port" {
  description = "web container ingress TCP port"
  default     = "8443"
}

variable "web_command" {
  description = "command list for web container"
  default     = ["/opt/chownow/ecs/start_hermosa_web.sh"]
}

variable "web_container_healthcheck_interval" {
  description = "web container healthcheck interval"
  default     = 20
}

variable "web_container_healthcheck_timeout" {
  description = "web container healthcheck timeout"
  default     = 10
}

variable "web_container_healthcheck_target" {
  description = "web container healthcheck endpoint"
  default     = "/health"
}

variable "web_ecr_repository_uri" {
  description = "ECR repository uri for the web container"
}

variable "web_ecs_service_desired_count" {
  description = "desired number of web task instances to run"
  default     = 2
}

## manage container vars
variable "manage_container_image_version" {
  description = "the manage container image version"
  default     = "manage-latest"
}

variable "manage_ecr_repository_uri" {
  description = "ECR repository uri for the manage container"
  default     = ""
}

variable "manage_command" {
  description = "manage container command"
  default     = ["/bin/bash", "/opt/chownow/ecs/data_update.sh"]
}

variable "manage_task_cpu" {
  description = "minimum cpu required for the manage task to be scheduled"
  default     = 2048
}

variable "manage_task_memory" {
  description = "minimum memory required for the manage task to be scheduled"
  default     = 4096
}

## firelens vars

variable "firelens_container_name" {
  description = "firelens container name"
  default     = "log_router"
}

variable "firelens_container_ssm_parameter_name" {
  description = "firelens container ssm parameter name"
  default     = "/aws/service/aws-for-fluent-bit"
}

# stable version semver can be found here – https://github.com/aws/aws-for-fluent-bit/blob/mainline/AWS_FOR_FLUENT_BIT_STABLE_VERSION
variable "firelens_container_image_version" {
  description = "firelens container image version (tag)"
  default     = "2.25.1"
}

variable "firelens_options_dd_host" {
  description = "Host URI of the datadog log endpoint"
  default     = "http-intake.logs.datadoghq.com"
}

variable "dd_trace_enabled" {
  description = "Enable/disable datadog dd_trace"
  default     = true
}

variable "dd_agent_container_image_version" {
  description = "Datadog agent container image version (tag)"
  default     = "7"
}

variable "enable_execute_command" {
  description = "enable execution of command into a container"
  default     = true
}

variable "read_only_root_filesystem" {
  description = "make the container root filesystem readonly"
  default     = false
}

variable "ops_config_version" {
  description = "version of ops repository used to generate the configuration"
  default     = "master"
}

## Sysdig vars

variable "enable_sysdig" {
  description = "enable/disable sysdig"
  default     = false
}

variable "sysdig_agent_container_image_version" {
  description = "Sysdig workload agent container image version (tag)"
  default     = "latest"
}

variable "sysdig_orchestrator_port" {
  description = "Sysdig ECS Orchestrator port"
  default     = 6667
}

locals {
  api_container_name           = "hermosa-api"
  web_container_name           = "hermosa-web"
  manage_container_name        = "hermosa-manage"
  datadog_container_name       = "datadog-agent"
  sysdig_container_name        = "sysdig-agent"
  web_entrypoint               = var.enable_sysdig ? ["/opt/draios/bin/instrument"] : []
  api_entrypoint               = var.enable_sysdig ? ["/opt/draios/bin/instrument"] : []
  manage_entrypoint            = var.enable_sysdig ? ["/opt/draios/bin/instrument", "sh", "-c"] : ["sh", "-c"]
  sysdig_orchestrator_host     = var.enable_sysdig ? data.aws_lb.sysdig_orchestrator[0].dns_name : ""
  volumes_from                 = var.enable_sysdig ? local.volumes_from_sysdig : local.volumes_from_default
  depends_on                   = var.enable_sysdig ? local.depends_on_sysdig : local.depends_on_default
  manage_volumes_from          = var.enable_sysdig ? local.volumes_from_sysdig : local.manage_volumes_from_default
  manage_depends_on            = var.enable_sysdig ? local.depends_on_sysdig : local.manage_depends_on_default
  container_definitions        = var.enable_sysdig ? jsonencode(local.web_service_container_definitions_sysdig) : jsonencode(local.web_service_container_definitions)
  manage_container_definitions = var.enable_sysdig ? jsonencode(local.manage_task_container_definitions_sysdig) : jsonencode(local.manage_task_container_definitions)
  manage_role                  = local.service_role == "" ? "manage" : "${local.service_role}-manage"
  target_group_arns            = var.webhook_alb_name != "" ? { lb1 = module.alb_ecs_tg.tg_arn, lb2 = module.alb_ecs_webhook_tg[0].tg_arn } : { lb1 = module.alb_ecs_tg.tg_arn }
  web_base_dd_version          = "${var.web_container_image_version}-${var.ops_config_version}"
  web_dd_version               = length(var.deployment_suffix) > 0 ? "${local.web_base_dd_version}-${var.deployment_suffix}" : local.web_base_dd_version
  base_dd_tags                 = "env:${local.env},config_version:${var.ops_config_version},cn_namespace:${local.service}"
  web_base_dd_tags             = "${local.base_dd_tags},version:${var.web_container_image_version}"
  web_dd_tags                  = length(var.deployment_suffix) > 0 ? "${local.web_base_dd_tags},deployment_suffix:${var.deployment_suffix}" : local.web_base_dd_tags
  api_base_dd_version          = "${var.api_container_image_version}-${var.ops_config_version}"
  api_dd_version               = length(var.deployment_suffix) > 0 ? "${local.api_base_dd_version}-${var.deployment_suffix}" : local.api_base_dd_version
  api_base_dd_tags             = "${local.base_dd_tags},version:${var.api_container_image_version}"
  api_dd_tags                  = length(var.deployment_suffix) > 0 ? "${local.api_base_dd_tags},deployment_suffix:${var.deployment_suffix}" : local.api_base_dd_tags
  manage_base_dd_version       = "${var.manage_container_image_version}-${var.ops_config_version}"
  manage_dd_version            = length(var.deployment_suffix) > 0 ? "${local.manage_base_dd_version}-${var.deployment_suffix}" : local.manage_base_dd_version
  manage_base_dd_tags          = "${local.base_dd_tags},version:${var.manage_container_image_version}"
  manage_dd_tags               = length(var.deployment_suffix) > 0 ? "${local.manage_base_dd_tags},deployment_suffix:${var.deployment_suffix}" : local.manage_base_dd_tags
}
