variable "env" {
  description = "unique environment/stage name"
  default     = "dev"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "menu"
}

variable "service_id" {
  description = "unique service identifier, eg '-in' => integrations-in"
  default     = ""
}

variable "deployment_suffix" {
  description = "suffix used to name service and lookup of the name of target group to attach to"
  default     = ""
}

variable "vpc_name_prefix" {
  description = "prefix added to var.env to select which vpc the service will on"
  type        = string
  default     = "main"
}

variable "container_web_image_registry_url" {
  description = "image registry url, e.g. 449190145484.dkr.ecr.us-east-1.amazonaws.com"
  default     = "449190145484.dkr.ecr.us-east-1.amazonaws.com"
}

variable "container_web_image_name" {
  description = "web container image name, e.g. menu-service"
  default     = "menu-service"
}

variable "container_web_image_tag" {
  description = "web container image tag, e.g. 1c6184d"
}

variable "container_web_port" {
  description = "web container ingress tcp port, e.g. 8003"
  default     = "8003"
}

variable "database_user" {
  description = "database user"
  default     = "chownow"
}

#variable "database_password" {
#  description = "database password"
#}

#variable "database_host" {
#  description = "database host"
#}
#
#variable "readonly_db_host" {
#  description = "readonly database host"
#}

variable "database_name" {
  description = "database name"
  default     = "menu"
}

#variable "database_port" {
#  description = "database port"
#  default     = "3306"
#}

variable "firelens_container_name" {
  description = "firelens container name"
  default     = "log_router"
}

variable "firelens_container_ssm_parameter_name" {
  description = "firelens container ssm parameter name"
  default     = "/aws/service/aws-for-fluent-bit"
}

variable "firelens_container_image_version" {
  description = "firelens container image version (tag)"
  default     = "2.10.1"
}

variable "firelens_options_dd_host" {
  description = "Host URI of the datadog log endpoint"
  default     = "http-intake.logs.datadoghq.com"
}

#variable "jwt_secret" {
#  description = "JWT secret"
#}

variable "web_ecs_service_desired_count" {
  description = "desired number of web task instances to run"
  default     = 1
}

variable "web_ecs_service_max_count" {
  description = "max number of web task instances to run"
  default     = 8
}

variable "enable_execute_command" {
  description = "enable execution of command into a container"
  default     = false
}

variable "container_command" {
  description = "manage container command"
  default     = "echo hello"
}

variable "memory" {
  default = "2048"
}

variable "cpu" {
  default = "1024"
}

variable "task_memory" {
  description = "memory for a managed task"
  default     = "2048"
}

variable "task_cpu" {
  description = "cpu for a managed task"
  default     = "1024"
}

locals {
  env                   = "${var.env}${var.env_inst}"
  service               = "${var.service}${var.service_id}"
  container_web_name    = "${var.service}-web"
  container_manage_name = "${var.service}-manage"
  dd_service            = "${local.service}-api"
  dd_env                = local.env == "ncp" ? "prod" : local.env
}
