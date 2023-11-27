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
  default     = "8000"
}

variable "container_protocol" {
  description = "protocol spoken on container_port"
  default     = "HTTP"
}

variable "ecs_service_desired_count" {
  description = "number of services to run per container"
  default     = "1"
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
