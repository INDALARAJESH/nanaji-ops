variable "wait_for_steady_state" {
  description = "wait for deployment to be ready"
  default     = true
}
## secrets
variable "configuration_secret_arn" {
  description = "configuration secret arn"
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

## task container vars

variable "task_container_image_version" {
  description = "the task container image version"
  default     = "task-latest"
}

variable "task_ecr_repository_uri" {
  description = "ECR repository uri for the task container"
  default     = ""
}

variable "task_ecs_service_desired_count" {
  description = "desired number of task task instances to run"
  default     = 2
}

variable "task_command" {
  description = "task container command"
  default     = ["/bin/bash", "/opt/chownow/ecs/start_hermosa_task.sh"]
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

variable "dd_agent_container_image_version" {
  description = "Datadog agent container image version (tag)"
  default     = "7"
}

variable "dd_trace_enabled" {
  description = "Enable/disable datadog dd_trace"
  default     = true
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
  task_container_name      = "hermosa-task"
  datadog_container_name   = "datadog-agent"
  sysdig_container_name    = "sysdig-agent"
  task_entrypoint          = var.enable_sysdig ? ["/opt/draios/bin/instrument"] : []
  sysdig_orchestrator_host = var.enable_sysdig ? data.aws_lb.sysdig_orchestrator[0].dns_name : ""
  volumes_from             = var.enable_sysdig ? local.volumes_from_sysdig : local.volumes_from_default
  depends_on               = var.enable_sysdig ? local.depends_on_sysdig : local.depends_on_default
  container_definitions    = var.enable_sysdig ? jsonencode(local.task_service_container_definitions_sysdig) : jsonencode(local.task_service_container_definitions)
  base_dd_tags             = "env:${local.env},config_version:${var.ops_config_version},cn_namespace:${local.service}"
  task_base_dd_version     = "${var.task_container_image_version}-${var.ops_config_version}"
  task_dd_version          = length(var.deployment_suffix) > 0 ? "${local.task_base_dd_version}-${var.deployment_suffix}" : local.task_base_dd_version
  task_base_dd_tags        = "${local.base_dd_tags},version:${var.task_container_image_version}"
  task_dd_tags             = length(var.deployment_suffix) > 0 ? "${local.task_base_dd_tags},deployment_suffix:${var.deployment_suffix}" : local.task_base_dd_tags
}
