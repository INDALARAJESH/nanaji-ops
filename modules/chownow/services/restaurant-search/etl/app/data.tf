data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private_base" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

data "aws_db_instance" "replica_db" {
  db_instance_identifier = local.replica_db_instance_id
}

data "aws_secretsmanager_secret" "replica_db_user" {
  name = "${local.env}/${var.service}/replica_db_username"
}

data "aws_secretsmanager_secret_version" "replica_db_user" {
  secret_id = data.aws_secretsmanager_secret.replica_db_user.id
}

data "aws_secretsmanager_secret" "replica_db_password" {
  name = "${local.env}/${var.service}/replica_db_password"
}

data "aws_secretsmanager_secret_version" "replica_db_password" {
  secret_id = data.aws_secretsmanager_secret.replica_db_password.id
}

data "aws_elasticsearch_domain" "restaurant_search" {
  domain_name = "restaurant-search-${local.es_domain_name_suffix}"
}

data "aws_secretsmanager_secret" "es_access_key_id" {
  name = "${local.es_domain_name_suffix}/restaurant-search/es_access_key_id"
}

data "aws_secretsmanager_secret_version" "es_access_key_id" {
  secret_id = data.aws_secretsmanager_secret.es_access_key_id.id
}

data "aws_secretsmanager_secret" "es_secret_access_key" {
  name = "${local.es_domain_name_suffix}/restaurant-search/es_secret_access_key"
}

data "aws_secretsmanager_secret_version" "es_secret_access_key" {
  secret_id = data.aws_secretsmanager_secret.es_secret_access_key.id
}

data "aws_secretsmanager_secret" "dd_api_key" {
  name = "${var.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id = data.aws_secretsmanager_secret.dd_api_key.id
}
