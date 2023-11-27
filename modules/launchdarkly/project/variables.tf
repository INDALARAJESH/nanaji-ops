# Required
variable "id" {
  description = "Unique key for the project in kebabcase (system / service)"
  type        = string
}

variable "name" {
  description = "Name for project (system / service name)"
  type        = string
}

variable "envs" {
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

variable "tags" {
  description = "Additional tags to add on to the project. By default adds terraform."
  type        = list(string)
  default     = []
}
