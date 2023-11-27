variable "ecs_log_retention_in_days" {
  description = "number of days to retain log files"
  default     = "30"
}

variable "ecs_service_desired_count" {
  description = "number of services to run per container"
  default     = "2"
}

variable "task_cpu" {
  description = "CPU units for the container"
  default     = "1024"
}

variable "task_memory" {
  description = "Memory limit for the container"
  default     = "2048"
}

variable "wait_for_steady_state" {
  description = "wait for deployment to be ready"
  default     = true
}

variable "web_scaling_min_capacity" {
  description = "minimum amount of containers to support in the autoscaling configuration"
  default     = 2
}

variable "web_scaling_max_capacity" {
  description = "maximum amount of containers to support in the autoscaling configuration"
  default     = 8
}

variable "web_policy_scale_in_cooldown" {
  description = "the amount of time to wait until the next scaling event"
  default     = 300
}

variable "enable_execute_command" {
  description = "enable execution of command into a container"
  default     = true
}

variable "ops_ecr_address" {
  description = "ops marketplace repository address"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com"
}

variable "propagate_tags" {
  description = "specifies how to propagate tags to running tasks, valid values are SERVICE or TASK_DEFINITION"
  default     = "SERVICE"
}

variable "dd_agent_container_image_version" {
  description = "Datadog agent container image version (tag)"
  default     = "7"
}

# Marketplace Environment Variables
variable "marketplace_container_port" {
  description = "Marketplace TCP port"
  default     = "3000"
}

variable "container_protocol" {
  description = "protocol spoken on container_port"
  default     = "HTTP"
}

variable "image_tag" {
  description = "service image tag"
  default     = "main"
}

variable "marketplace_log_level" {
  description = "task definition marketplace log level environment variable"
  default     = "INFO"
}

variable "sentry_dsn" {
  description = "Sentry.io API key"
  default     = "https://d905c9e410ab415391a182c46b90578b@o32006.ingest.sentry.io/6108690"
}

variable "marketplace_command" {
  description = "marketplace container command"
  default     = ["/bin/sh", "entrypoint.sh"]
}

variable "launch_darkly_id" {
  description = "LaunchDarkly ID"
  default     = "61f8128467ed48159707692c"
}

variable "google_maps_client_key" {
  description = "Client Key for Google Map API"
  default     = "AIzaSyDKks4-Thrc6n-iLK8p-KLRUFq-Jb5i2nk"
}

variable "google_oauth_client_id" {
  description = "Client ID for Google Map API"
  default     = "938991976367-no5a1t6dnds8fulk9cae3mjeropqg43i.apps.googleusercontent.com"
}

variable "google_analytics_id" {
  description = "Analytics ID for Google"
  default     = "UA-83904909-2"
}

variable "facebook_oauth_app_id" {
  description = "Application ID for Facebook Oauth"
  default     = "391736507867606"
}

variable "sentry_auth_token" {
  description = "Sentry Auth Token"
  default     = "eaf8238075114a9e8fef2d5ccba72c92dc4601c7f4e74c079706b49935edc843"
}

variable "branch_io_key" {
  description = "Branch IO Key"
  default     = "key_test_af6iSXMCdo6PEjf2LjJJTaleDDpXw7Yz"
}

### Sysdig variables
variable "sysdig_orchestrator_port" {
  description = "Sysdig ECS Orchestrator port"
  default     = 6667
}

variable "enable_sysdig" {
  description = "enable/disable sysdig"
  default     = false
}


locals {
  marketplace_container_name = "${var.service}-${local.env}"
  datadog_container_name     = "datadog-agent"
  marketplace_entrypoint     = var.enable_sysdig ? ["/opt/draios/bin/instrument"] : []
  api_host                   = var.env == "prod" ? "https://api.chownow.com/api" : "https://api.${local.env}.svpn.chownow.com/api"
  dd_tags                    = "env:${local.env},role:service"
  marketplace_ecr_repo       = "${var.ops_ecr_address}/${var.service}"
  sysdig_orchestrator        = "sysdig-fargate-orchestrator-nlb.${local.env}.aws.chownow.com"
}
