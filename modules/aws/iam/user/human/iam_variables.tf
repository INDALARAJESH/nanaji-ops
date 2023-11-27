variable "first_name" {
  description = "human's first name"
}

variable "last_name" {
  description = "human's last name"
}

variable "iam_groups" {
  description = "list of IAM groups to attach to user"
  default     = []
}

variable "enable_user" {
  description = "on/off toggle to allow user to be disabled when embedded in a module"
  default     = "1"
}
