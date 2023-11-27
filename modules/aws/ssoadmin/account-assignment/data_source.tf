data "aws_ssoadmin_instances" "sso" {}

data "aws_ssoadmin_permission_set" "sso" {
  instance_arn = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  name         = var.permission_set_name
}

data "aws_identitystore_group" "sso" {
  count             = var.principal_type == "group" ? 1 : 0
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = var.principal_name
  }
}

data "aws_identitystore_user" "sso" {
  count             = var.principal_type == "user" ? 1 : 0
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]

  filter {
    attribute_path  = "UserName"
    attribute_value = var.principal_name
  }
}
