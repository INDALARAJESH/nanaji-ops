variable "log_statement" {
  default = "ddl"
}

variable "log_min_duration_statement" {
  default = "3000"
}

variable "shared_preload_libraries" {
  default = "pg_stat_statements"
}

variable "track_activity_query_size" {
  default = "2048"
}

variable "pg_stat_statements_track" {
  default = "ALL"
}

variable "autovacuum_naptime" {
  default = "300"
}

variable "autovacuum_vacuum_threshold" {
  default = "5000"
}

variable "log_autovacuum_min_duration" {
  default = "1"
}

variable "max_connections" {
  default = "256"
}

variable "standard_conforming_strings" {
  default = "1"
}

variable "work_mem" {
  default = "64000"
}

variable "rds_logical_replication" {
  default = "0"
}

variable "wal_sender_timeout" {
  default = "30000"
}

variable "db_parameter_group_family" {
  description = "the AWS provided database family value"
  default     = "postgres11"
}
