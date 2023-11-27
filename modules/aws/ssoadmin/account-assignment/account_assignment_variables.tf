variable "permission_set_name" {
  description = "name of the permission set"
  type        = string
}

variable "principal_name" {
  description = "name of the principal user or group"
  type        = string
}

variable "principal_type" {
  description = "type of the principal: user or group"
  type        = string
}

variable "account_id" {
  description = "account id"
  type        = string
}

locals {
  principal_id   = var.principal_type == "group" ? data.aws_identitystore_group.sso[0].group_id : data.aws_identitystore_user.sso[0].user_id
  principal_type = var.principal_type == "group" ? "GROUP" : "USER"
}
