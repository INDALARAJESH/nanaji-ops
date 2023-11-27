module "rds_postgres" {
  source                     = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.1.3"
  env                        = var.env
  service                    = local.service
  vpc_name_prefix            = var.vpc_name_prefix
  db_allocated_storage       = var.rds_allocated_storage
  db_backup_retention_period = var.rds_backup_retention_period
  db_instance_class          = var.rds_instance_class
  db_storage_type            = var.rds_storage_type
  rds_logical_replication    = var.rds_logical_replication
  wal_sender_timeout         = var.wal_sender_timeout
  log_statement              = var.log_statement
  log_min_duration_statement = var.log_min_duration_statement
}

module "ec_redis" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticache/redis?ref=aws-elasticache-redis-v2.0.1"

  env             = var.env
  service         = local.service
  vpc_name_prefix = var.vpc_name_prefix

  ec_rg_node_type                  = var.ec_rg_node_type
  ec_rg_number_cache_clusters      = var.ec_rg_number_cache_clusters
  ec_rg_automatic_failover_enabled = var.ec_rg_automatic_failover_enabled
  elasticache_param_family         = var.ec_param_family
}
