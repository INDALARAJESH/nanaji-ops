# ECS Task Definition Variables
variable "container_entrypoint" {
  description = "container entrypoint for task definition"
  default     = "/src/entrypoint.sh"
}

variable "sherlock_log_level" {
  description = "task definition sherlock log level environment variable"
  default     = "INFO"
}

variable "redis_port" {
  description = "Redis TCP port"
  default     = "6379"
}

variable "sfdc_login" {
  description = "Salesforce Login URL"
  default     = "https://test.salesforce.com/"
}

variable "sfdc_recordtype_id" {
  description = "Salesforce record type ID"
  default     = "012G0000001YiQS"
}

variable "consecutive_threshold" {
  description = "how many times an id triggers the scanner before a case is made"
  default     = "3"
}

variable "percentage_to_scan" {
  description = "How many cases based on percentage the scanner will process"
  default     = "100"
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
