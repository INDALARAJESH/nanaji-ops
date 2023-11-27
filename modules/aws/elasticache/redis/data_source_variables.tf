variable "vpc_name_prefix" {
  description = "VPC name which is used to determine where to create resources"
  default     = "main"
}

variable "vpc_private_subnet_tag_value" {
  description = "Used to filter down available subnets"
  default     = "private_base"
}

locals {
  create_redis_authtoken = var.authtoken_secret_name == "" ? 1 : 0
  redis_authtoken        = local.create_redis_authtoken == 1 ? join("", random_password.redis_authtoken.*.result) : join("", data.aws_secretsmanager_secret_version.redis_auth_token.*.secret_string)
  vpc_subnet_cidrs       = [for s in data.aws_subnet.private : s.cidr_block]
}
