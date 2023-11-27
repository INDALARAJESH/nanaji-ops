variable "secret_recovery_window" {
  description = "allows for secret recovery when deleted, but causes issues when rebuilding infra"
  default     = 0
}

variable "secret_name" {
  description = "name of secret"
  default     = "redis_auth_token"
}
