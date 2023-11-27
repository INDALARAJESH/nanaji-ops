variable "string_length" {
  description = "character length of secret"
  default     = 32
}

variable "string_special" {
  description = "boolean option for including special charaters"
  default     = false
}

variable "string_upper" {
  description = "boolean to include uppercase characters"
  default     = true
}

variable "string_min_upper" {
  description = "minimum amount of uppercase characters to inclue"
  default     = 4
}

variable "string_lower" {
  description = "boolean to include lowercase charaters"
  default     = true
}

variable "string_min_lower" {
  description = "minimum amount of lowercase characters to inclue"
  default     = 4
}

variable "string_min_numeric" {
  description = "minimum amount of numeric characters to inclue"
  default     = 4
}

variable "string_min_special" {
  description = "minimum amount of special characters"
  default     = 0
}

variable "string_override_special" {
  description = "use custom special characters in the string"
  default     = ""
}

variable "recovery_window_in_days" {
  description = "allows for secret recovery when deleted, but causes issues when rebuilding infra"
  default     = 0
}


variable "secret_key" {
  description = "key name for storing secret in key value format"
  default     = ""
}
