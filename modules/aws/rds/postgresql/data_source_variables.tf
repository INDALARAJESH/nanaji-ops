variable "vpc_name_prefix" {
  description = "VPC name which is used to determine where to create resources"
}

variable "subnet_tag" {
  description = "Toggle public or private subnet"
  default     = "private"
}

variable "is_private" {
  description = "Toggle private or public zone"
  default     = true
}

variable "pgmaster_secret_name" {
  description = "Secrets Manager secret path"
  default     = ""
}

locals {
  create_pgmaster_password = var.pgmaster_secret_name == "" ? 1 : 0
  pgmaster_password = local.create_pgmaster_password == 1 ? join("", random_password.pgmaster_password.*.result) : join(
    "",
    data.aws_secretsmanager_secret_version.pgmaster_password.*.secret_string,
  )
}

