variable "ec_rg_node_type" {
  description = "elasticache replication group node type"
  default     = "cache.t2.micro"
}

variable "ec_rg_number_cache_clusters" {
  description = "number of cache clusters (primary and replicas) the replication group will have"
  default     = 1
}

// default = false because default var.ec_rg_number_cache_clusters < 2
variable "ec_rg_automatic_failover_enabled" {
  description = "enables/disables automatic failover for redis replication group"
  default     = false
}

variable "ec_rg_engine_version" {
  description = "the version number of the cache engine to be used for the cache clusters in this replication group"
  default     = "5.0.6"
}

variable "elasticache_param_family" {
  description = "elasticache parameter group family"
  default     = "redis5.0"
}

variable "vpc_name_prefix" {
  description = "prefix used to locate the vpc by name"
  default     = "main"
}

variable "snapshot_retention_limit" {
  description = "number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. 0 means snaphot disabled."
  default     = "0"
}

variable "snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "08:30-09:30"
}
