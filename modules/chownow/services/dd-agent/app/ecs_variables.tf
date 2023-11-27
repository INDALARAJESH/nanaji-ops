variable "config_dir" {
  description = "location of container's configuration directory"
  default     = "/etc/datadog-agent/conf.d/mysql.d"
}

variable "config_name" {
  description = "file name for configuration"
  default     = "conf.yaml"
}

variable "config_volume" {
  description = "configuration volume for containers"
  default     = "config-volume"
}
