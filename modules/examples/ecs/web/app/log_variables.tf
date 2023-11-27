#####################
# Logging Variables #
#####################

variable "firelens_container_name" {
  description = "firelens container name"
  default     = "log_router"
}

variable "firelens_container_ssm_parameter_name" {
  description = "firelens container ssm parameter name"
  default     = "/aws/service/aws-for-fluent-bit"
}

# https://hub.docker.com/r/amazon/aws-for-fluent-bit
variable "firelens_container_image_version" {
  description = "firelens container image version (tag)"
  default     = "2.22.0"
}

variable "firelens_options_dd_host" {
  description = "Host URI of the datadog log endpoint"
  default     = "http-intake.logs.datadoghq.com"
}
