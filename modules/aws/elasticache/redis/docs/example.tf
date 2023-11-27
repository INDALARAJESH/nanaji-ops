# Terraform (Standalone Redis):
module "redis_standalone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticache/redis?ref=aws-elasticache-redis-v2.0.9"

  env             = "sb"
  service         = "dms"
  vpc_name_prefix = "nc"
}

# Terraform (Redis with read-replica):
# of read-replicas = ec_rg_number_cache_clusters - 1)
module "redis_with_replica" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticache/redis?ref=aws-elasticache-redis-v2.0.9"


  env             = "sb"
  service         = "dms"
  vpc_name_prefix = "nc"

  ec_rg_number_cache_clusters      = 2
  ec_rg_automatic_failover_enabled = true
}
