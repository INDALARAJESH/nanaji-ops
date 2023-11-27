################################
# Web Security Group Variables #
################################

variable "enable_egress_allow_all" {
  description = "allow egress all on web service"
  default     = 1
}


#########################
# Web Service Variables #
#########################

variable "web_name" {
  description = "short name of app"
  default     = "web"
}

variable "custom_cluster_name" {
  description = "custom cluster name to override default naming"
  default     = ""
}

variable "container_port" {
  description = "ingress TCP port for container"
  default     = "443"
}

variable "container_port_2" {
  description = "ingress TCP port for container"
  default     = "80"
}

variable "container_protocol" {
  description = "protocol spoken on container_port"
  default     = "HTTP"
}

variable "ecs_service_desired_count" {
  description = "number of services to run per container"
  default     = "1"
}

// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
variable "task_cpu" {
  description = "minimum cpu required for the task to be scheduled"
  default     = 4096
}

// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
variable "task_memory" {
  description = "minimum memory required for the task to be scheduled"
  default     = 8192
}


#########################
# Web Scaling Variables #
#########################

variable "web_scaling_min_capacity" {
  description = "minimum amount of containers to support in the autoscaling configuration"
  default     = 4
}

variable "web_scaling_max_capacity" {
  description = "maximum amount of containers to support in the autoscaling configuration"
  default     = 10
}

variable "web_policy_scale_in_cooldown" {
  description = "the amount of time to wait until the next scaling event"
  default     = 300
}

variable "policy_target_conditions" {
  description = "ECS scaling target tracking conditions"
  default = [
    {
      metric = "ECSServiceAverageCPUUtilization"
      value  = 30
    },
    {
      metric = "ECSServiceAverageMemoryUtilization"
      value  = 30
    },
  ]
}

#############################
# Logging Sidecar Variables #
#############################

variable "firelens_container_name" {
  description = "firelens container name"
  default     = "log_router"
}

variable "fluentbit_container_ssm_parameter_name" {
  description = "firelens container ssm parameter name"
  default     = "/aws/service/aws-for-fluent-bit"
}

# stable version semver can be found here – https://github.com/aws/aws-for-fluent-bit/blob/mainline/AWS_FOR_FLUENT_BIT_STABLE_VERSION
variable "fluentbit_container_image_version" {
  description = "firelens container image version (tag)"
  default     = "2.25.1"
}

variable "firelens_options_dd_host" {
  description = "Host URI of the datadog log endpoint"
  default     = "http-intake.logs.datadoghq.com"
}

locals {
  host_volumes = [
    {
      name = "efs"
      efs_volume_configuration = [{
        file_system_id          = data.aws_efs_file_system.selected.file_system_id
        root_directory          = "/"
        transit_encryption      = "ENABLED"
        transit_encryption_port = 2999
      }]

    }
  ]

  runtime_platform = [{
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }]

  web_dd_tags = "env:${local.env}"
}
