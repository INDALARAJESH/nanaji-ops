# ECS Task Definition Variables
variable "web_log_level" {
  description = "task definition web log level environment variable"
  default     = "INFO"
}

variable "image_tag" {
  description = "service image tag"
  default     = "0.0.1"
}

variable "sentry_dsn" {
  description = "Sentry.io API key"
  default     = "UPDATETHISTOTHEREALDSNFORYOURSERVICE"
}

variable "efs_container_path" {
  description = "efs_container_path"
  default     = "/appsmith-stacks"
}

variable "image" {
  description = "image"
  default     = "appsmith/appsmith-ce"
}
