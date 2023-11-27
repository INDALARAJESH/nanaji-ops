################################
# DB Parameter Group Variables #
################################

variable "db_parameter_family" {
  description = "database family for db parameter groups"
  default     = "aurora-mysql5.7"
}

variable "db_long_query_time" {
  description = "database long query time"
  default     = "15"
}

variable "db_engine" {
  description = "Specifies the name of the engine"
  default     = "aurora-mysql"
}

variable "db_engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  default     = "mysql"
}

variable "db_major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  default     = "5.7"
}

variable "sql_mode" {
  description = "sql mode"
  default     = "NO_ENGINE_SUBSTITUTION"
}

variable "interactive_timeout" {
  description = "interactive timeout"
  default     = "1000"
}

variable "wait_timeout" {
  description = "wait timeout"
  default     = "1000"
}

variable "max_allowed_packet" {
  description = "max_allowed_packet"
  default     = "1073741824"
}

variable "table_open_cache" {
  description = "table_open_cache"
  default     = "10000"
}

variable "sort_buffer_size" {
  description = "sort_buffer_size"
  default     = "524288"
}

variable "max_heap_table_size" {
  description = "max_heap_table_size"
  default     = "104857600"
}

variable "tmp_table_size" {
  description = "tmp_table_size"
  default     = "104857600"
}

variable "innodb_stats_persistent_sample_pages" {
  description = "innodb_stats_persistent_sample_pages"
  default     = "200"
}

########################
# DB Cluster Variables #
########################
variable "db_database_name" {
  description = "database name inside of Aurora cluster"
  default     = "hermosa"
}

variable "db_snapshot_identifier" {
  description = "ARN of snapshot to restore"
  default     = ""
}

variable "db_username" {
  description = "database username"
  default     = "chownow"
}

variable "db_engine_version" {
  description = "database engine version"
  default     = "5.7.mysql_aurora.2.11.3"
}

variable "db_backup_retention_period" {
  description = "database backup retention period"
  default     = 1
}

variable "db_apply_immediately" {
  description = "boolean to allow changes to be applied immediately"
  default     = false
}

variable "db_allow_major_version_upgrade" {
  description = "allow major db version upgrade"
  default     = false
}

variable "db_iam_database_authentication_enabled" {
  description = "enables/disables database IAM authentication method"
  default     = true
}

#########################
# DB Instance Variables #
#########################

variable "count_cluster_instances" {
  description = "the number of database instances to create in the cluster"
  default     = 2
}

variable "db_performance_insights_enabled" {
  description = "boolean to enable/disable performance insights on database instance"
  default     = false
}

variable "db_instance_class" {
  description = "database instance size"
  default     = "db.t2.small"
}


####################
# DB DNS Variables #
####################

variable "db_cname_endpoint" {
  description = "subdomain to use for database endpoint"
  default     = "db-master"
}

variable "db_cname_endpoint_reader" {
  description = "subdomain to use for database endpoint"
  default     = "db-replica"
}

variable "private_dns_zone" {
  description = "boolean to specify if dns zone is private"
  default     = true
}
