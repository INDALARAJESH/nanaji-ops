## mysql container vars
variable "mysql_container_image_version" {
  description = "the mysql container image version"
  default     = "5.7-v1"
}

variable "mysql_ecr_repository_uri" {
  description = "ECR repository uri for the task container"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa-mysql"
}

## redis container vars
variable "redis_container_image_version" {
  description = "the redis container image version"
  default     = "v1"
}

variable "redis_ecr_repository_uri" {
  description = "ECR repository uri for the task container"
  default     = "229179723177.dkr.ecr.us-east-1.amazonaws.com/hermosa-redis"
}

## elasticsearch container vars
variable "elasticsearch_container_image_version" {
  description = "the elasticsearch container image version"
  default     = "5.5.0"
}

variable "elasticsearch_ecr_repository_uri" {
  description = "ECR repository uri for the task container"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/elasticsearch"
}

## config container vars
variable "config_container_image_version" {
  description = "the config container image version"
  default     = "v1"
}

variable "config_ecr_repository_uri" {
  description = "ECR repository uri for the task container"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com/ops-config"
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
  default     = "443"
}

variable "web_container_healthcheck_interval" {
  description = "web container healthcheck interval"
  default     = 10
}

variable "web_container_healthcheck_target" {
  description = "web container healthcheck endpoint"
  default     = "/health"
}

variable "web_ecr_repository_uri" {
  description = "ECR repository uri for the web container"
  default     = ""
}

variable "web_ecs_service_desired_count" {
  description = "desired number of web task instances to run"
  default     = 1
}

variable "web_ecs_service_max_count" {
  description = "max number of web task instances to run"
  default     = 1
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
  default     = 1
}

variable "task_ecs_service_max_count" {
  description = "max number of task task instances to run"
  default     = 10
}

variable "task_cpu" {
  description = "minimum cpu required for the manage task to be scheduled"
  default     = 2048
}

variable "task_memory" {
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

# Datadog Agent

variable "dd_agent_container_image_version" {
  description = "Datadog agent container image version (tag)"
  default     = "7"
}

variable "enable_egress_allow_all" {
  description = "boolean to enable egress allow all"
  default     = 1
}

locals {
  api_container_name  = "hermosa-api"
  web_container_name  = "hermosa-web"
  task_container_name = "hermosa-task"
}

variable "ops_config_version" {
  description = "the version of ops repository used to generate the configuration"
  default     = "master"
}
