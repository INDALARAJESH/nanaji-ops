#####################
# Logging Variables #
#####################

# This lookup provides the ecr repo and container image for the amazon provided
# logging sidecar image for firelens/fluentbit logging to datadog
data "aws_ssm_parameter" "fluentbit" {
  name = format("%s/%s", var.firelens_container_ssm_parameter_name, var.firelens_container_image_version)
}

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
  default     = "stable"
}

variable "firelens_options_dd_host" {
  description = "Host URI of the datadog log endpoint"
  default     = "http-intake.logs.datadoghq.com"
}

variable "log_retention_in_days" {
  description = "log retention for containers"
  default     = 30
}
