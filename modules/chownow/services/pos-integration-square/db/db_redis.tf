module "ec_redis" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticache/redis?ref=aws-elasticache-redis-v2.0.2"

  env             = var.env
  service         = local.service
  vpc_name_prefix = var.vpc_name_prefix

  ec_rg_node_type                  = var.ec_rg_node_type
  ec_rg_number_cache_clusters      = var.ec_rg_number_cache_clusters
  ec_rg_automatic_failover_enabled = var.ec_rg_automatic_failover_enabled
  elasticache_param_family         = var.ec_param_family
}
