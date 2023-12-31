module "ec_redis" {
  source                           = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticache/redis?ref=aws-elasticache-redis-v2.0.9"
  env                              = var.env
  env_inst                         = var.env_inst
  service                          = var.service
  vpc_name_prefix                  = var.vpc_name_prefix
  ec_rg_engine_version             = var.ec_rg_engine_version
  ec_rg_node_type                  = var.ec_rg_node_type
  ec_rg_number_cache_clusters      = var.ec_rg_number_cache_clusters
  ec_rg_automatic_failover_enabled = var.ec_rg_automatic_failover_enabled
  elasticache_param_family         = var.elasticache_param_family
  snapshot_name                    = var.snapshot_name
  snapshot_retention_limit         = var.snapshot_retention_limit
  snapshot_window                  = var.snapshot_window
  custom_name                      = var.custom_name
  custom_cname_endpoint            = var.custom_cname_endpoint
  custom_vpc_name                  = var.custom_vpc_name
  additional_security_groups       = [data.aws_security_group.internal.id]
  availability_zones               = var.availability_zones
  private_dns_zone                 = var.private_dns_zone
  dns_zone                         = var.dns_zone
}
