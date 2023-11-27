# Required

variable "id" {
  description = "Unique key for the custom role in kebabcase"
  type        = string
}

variable "name" {
  description = "Name for the custom role"
  type        = string
}

variable "policy_statements" {
  description = "List of policy statement objects (effect, resources, and actions)"
  type = list(object({
    effect    = string
    resources = list(string)
    actions   = list(string)
  }))
  default = []
}

# Optional

variable "description" {
  description = "Description for the custom role"
  type        = string
  default     = null
}
