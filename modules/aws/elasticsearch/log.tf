module "search_log_group" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudwatch/log-group?ref=aws-cloudwatch-log-group-v2.0.0"
  count    = var.log_publishing_search_enabled == "true" ? 1 : 0
  env      = var.env
  env_inst = var.env_inst
  name     = "search"
  path     = "/aws/aes/domains/${local.domain_name}"
}

module "index_log_group" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudwatch/log-group?ref=aws-cloudwatch-log-group-v2.0.0"
  count    = var.log_publishing_index_enabled == "true" ? 1 : 0
  env      = var.env
  env_inst = var.env_inst
  name     = "index"
  path     = "/aws/aes/domains/${local.domain_name}"
}

module "application_log_group" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudwatch/log-group?ref=aws-cloudwatch-log-group-v2.0.0"
  count    = var.log_publishing_application_enabled == "true" ? 1 : 0
  env      = var.env
  env_inst = var.env_inst
  name     = "application"
  path     = "/aws/aes/domains/${local.domain_name}"
}
