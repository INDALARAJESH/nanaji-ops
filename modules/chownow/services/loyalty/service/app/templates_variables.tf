# ECS Task Definition Variables
variable "container_entrypoint" {
  description = "container entrypoint for task definition"
  default     = "./entrypoint.sh"
}

variable "loyalty_log_level" {
  description = "task definition loyalty log level environment variable"
  default     = "INFO"
}

# Firelens
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
