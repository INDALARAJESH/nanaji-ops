variable "is_kv" {
  description = "is secret a key-value pair"
  default     = false
}

variable "recovery_window_in_days" {
  description = "allows for secret recovery when deleted, but causes issues when rebuilding infra"
  default     = 0
}

variable "secret_description" {
  description = "description of secret"
  type        = string
}

variable "secret_plaintext" {
  description = "plaintext secret value"
  type        = string
  default     = ""
}

variable "secret_kv" {
  description = "kv secret value"
  type        = map
  default     = {}
}

variable "secret_name" {
  description = "name of secret"
  type        = string
}
