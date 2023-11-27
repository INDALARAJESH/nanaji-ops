## RDS Variables
variable "rds_allocated_storage" {
  description = "size of rds db disk in gb"
  default     = 10
}

variable "rds_backup_retention_period" {
  description = "snapshot retention period in days"
  default     = 1
}

variable "rds_instance_class" {
  description = "rds database instance class"
  default     = "db.t3.small"
}

variable "rds_storage_type" {
  description = "type of rds storage"
  default     = "gp2"
}

variable "rds_logical_replication" {
  description = "enable logical replication"
  default     = 0
}


## Elasticache Variables

variable "ec_rg_node_type" {
  description = "elasticache replication group node type"
  default     = "cache.t2.micro"
}

variable "ec_rg_number_cache_clusters" {
  description = "number of cache clusters (primary and replicas) the replication group will have"
  default     = 1
}

variable "ec_rg_automatic_failover_enabled" {
  description = "enables/disables automatic failover for redis replication group"
  default     = false
}

variable "ec_param_family" {
  description = "elasticache parameter group family"
  default     = "redis5.0"
}

variable "wal_sender_timeout" {
  default = 0
}

variable "log_statement" {
  default = "none"
}

variable "log_min_duration_statement" {
  default = "-1"
}
