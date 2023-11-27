variable "container_port" {
  description = "ingress TCP port for container"
  default     = "8000"
}

#################################
# ECS Task Definition Variables #
#################################
variable "container_entrypoint_web" {
  description = "container entrypoint for task definition"
  default     = "/code/entrypoint.sh"
}

variable "container_entrypoint_task" {
  description = "container entrypoint for task definition"
  default     = "/code/dms/entrypoint_celery.sh"
}

variable "container_entrypoint_scheduler" {
  description = "container entrypoint for scheduler definition"
  default     = "/code/dms/entrypoint_celery.sh"
}

variable "td_env_app_log_level" {
  description = "task definition app log level environment variable"
  default     = "INFO"
}

variable "td_env_sendgrid_delighted_enabled" {
  description = "task definition environment variable to enable/disable sendgrid delighted"
  default     = "false"
}

variable "web_container_tag" {
  description = "The current container tag used in the production deployment"
}

variable "task_container_tag" {
  description = "The current container tag used in the production deployment"
}

variable "manage_container_tag" {
  description = "The current container tag used in the production deployment"
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
