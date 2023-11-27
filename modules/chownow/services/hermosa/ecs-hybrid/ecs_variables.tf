## api
variable "api_container_image_version" {
  description = "the api container image version"
  default     = "api-latest"
}

variable "api_ecr_repository_uri" {
  description = "ECR repository uri for the api container"
  default     = ""
}

## web
variable "web_container_image_version" {
  description = "the image version used to start the web container"
  default     = "web-latest"
}

variable "web_ecr_repository_uri" {
  description = "ECR repository uri for the web container"
}

variable "web_ecs_service_desired_count" {
  description = "Number of desired instances of api service"
  default     = 1
}

## task
variable "task_container_image_version" {
  description = "the task container image version"
  default     = "task-latest"
}

variable "task_ecr_repository_uri" {
  description = "ECR repository uri for the task container"
  default     = ""
}

variable "task_ecs_service_desired_count" {
  description = "Number of desired instances of task service"
  default     = 1
}

# datadog

variable "dd_agent_container_image_version" {
  description = "Datadog agent container image version (tag)"
  default     = "7"
}

variable "wait_for_steady_state" {
  description = "wait for deployment to be ready"
  default     = true
}

variable "ops_config_version" {
  description = "the version of ops repository used to generate the configuration"
  default     = "master"
}
