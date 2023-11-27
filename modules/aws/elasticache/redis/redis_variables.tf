variable "authtoken_secret_name" {
  description = "Secrets Manager secret path to the Redis Auth Token"
  default     = ""
}



variable "ec_at_rest_encryption_enabled" {
  description = "enables/disables encrpytion at rest"
  default     = true
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

variable "ec_rg_node_type" {
  description = "elasticache replication group node type"
  default     = "cache.t2.micro"
}

variable "ec_rg_number_cache_clusters" {
  description = "number of cache clusters (primary and replicas) the replication group will have"
  default     = 1
}

variable "elasticache_param_family" {
  description = "elasticache parameter group family"
  default     = "redis5.0"
}

variable "redis_tcp_port" {
  description = "Ingress redis TCP port"
  default     = "6379"
}

variable "replicas_per_node_group" {
  description = "replicas per node group"
  default     = 1
}

variable "num_node_groups" {
  description = "number of node groups in cluster"
  default     = 2
}

variable "transit_encryption_enabled" {
  description = "boolean to enable transit encryption"
  default     = true
}

variable "custom_parameter_group_name" {
  description = "custom parameter group to use with elasticache cluster"
  default     = ""
}

variable "enable_parameter_group" {
  description = "enable parameter group creation in module"
  default     = 1
}

variable "multi_az_enabled" {
  description = "boolean to enable/disable multi-az"
  default     = true
}

variable "snapshot_name" {
  description = "name of snapshot to use to restore data. It will create a new resource if changed."
  default     = ""
}

variable "snapshot_retention_limit" {
  description = "number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. 0 means snaphot disabled."
  default     = "0"
}

variable "snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "08:30-09:30"
}

#####################
# Route53 Variables #
#####################

variable "custom_cname_endpoint" {
  description = "custom cname endpoint name for A record creation"
  default     = ""
}

variable "enable_record_redis_reader" {
  description = "enable/disable creation of redis reader cname"
  default     = 1
}

variable "db_name_suffix" {
  description = "name suffix for cname"
  default     = "redis"
}

variable "dns_record_ttl" {
  description = "TTL for cname record"
  default     = "900"
}

variable "dns_record_type" {
  description = "database record type"
  default     = "CNAME"
}
