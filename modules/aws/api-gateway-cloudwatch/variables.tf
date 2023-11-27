variable "env" {
  description = "unique environment/stage name"
}

variable "create_iam" {
  description = "set to 1 to create IAM resources (once per account)"
  default     = 0
}
