module "search_service_replica_db_username" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Search service replica db username"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "replica_db_username"
  service     = var.service
}

module "search_service_replica_db_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Search service replica db password"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "replica_db_password"
  service     = var.service
}

module "datadog_log_forwarder_api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Datadog api key for log forwarding"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "ops_api_key"
  service     = var.service
}
