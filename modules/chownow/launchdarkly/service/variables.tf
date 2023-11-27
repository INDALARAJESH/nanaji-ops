# Required
variable "service_id" {
  description = "Unique key for the service / system in kebabcase."
  type        = string
}

variable "project_envs" {
  description = "List of unique environments with required id and names. Optional tags and colors"
  default = [
    {
      id   = "local"
      name = "Local"
      tags = []
    },
    {
      id   = "production"
      name = "Production"
      tags = []
    }
  ]
}

# Optional

variable "service_name_override" {
  description = "Human readable name for service / system"
  type        = string
  default     = null
}

variable "additional_job_functions_with_tags" {
  description = "Additional roles to create with further access control based on tag values"
  default     = {}
}
