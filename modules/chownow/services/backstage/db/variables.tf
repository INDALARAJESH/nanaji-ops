variable "service" {
  description = "the service name"
  type        = string
  default     = "backstage"
}

variable "env" {
  description = "the environment name"
  type        = string
  default     = "dev"
}

variable "vpc_name_prefix" {
  description = "prefix added to var.env to select which vpc the service will on"
  type        = string
  default     = "main"
}

variable "db_password_secret_name" {
  description = "AWS Secret Manager {secret-name} to store database password in /{env}/{service}/{secret-name} format"
  type        = string
  default     = "db_password"
}

variable "db_username" {
  type    = string
  default = "postgres"
}