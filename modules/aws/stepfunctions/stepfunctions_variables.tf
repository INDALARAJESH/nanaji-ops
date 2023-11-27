variable "step_function_name" {
  description = "step function name"
}

variable "step_function_definition" {
  description = "json-formatted step function definition"
}

variable "tracing_enabled" {
  description = "whether to enable tracing for step functions"
  default     = false
}