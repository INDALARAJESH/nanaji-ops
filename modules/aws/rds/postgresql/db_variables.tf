######################
# Database Variables #
######################

variable "db_instance_class" {
  description = "database instance size"
  default     = "db.t3.small"
}

variable "db_multi_az" {
  description = "boolean for turning on/off multi-az"
  default     = true
}

variable "db_engine" {
  description = "database kind"
  default     = "postgres"
}

variable "db_engine_version" {
  description = "database version"
  default     = "11.11"
}

variable "db_allocated_storage" {
  description = "size of db disk in gb"
  default     = 10
}

variable "db_storage_type" {
  description = "type of storage"
  default     = "gp2"
}

variable "db_storage_encrypted" {
  description = "type of storage"
  default     = true
}

variable "db_publicly_accessible" {
  description = "boolean for allowing public internet access"
  default     = false
}

variable "db_vpc_security_group_ids" {
  description = "aws security groups for database"
  default     = []
}

variable "db_auto_minor_version_upgrade" {
  description = "boolean for allowing automatic minor version upgrades"
  default     = false
}

variable "db_backup_retention_period" {
  description = "database backup retention period"
  default     = 1
}

variable "db_skip_final_snapshot" {
  description = "boolean to skip final snapshot for database"
  default     = true
}

variable "db_username" {
  description = "master database username"
  default     = "root"
}

variable "db_tcp_port" {
  description = "Ingress database TCP port"
  default     = "5432"
}

variable "db_ca_cert_identifier" {
  description = "database certificate identifier"
  default     = "rds-ca-rsa2048-g1"
}

variable "db_name_suffix" {
  description = "name suffix for cname"
  default     = "master"
}

variable "dns_record_ttl" {
  description = "TTL for cname record"
  default     = "900"
}

variable "dns_record_type" {
  description = "database record type"
  default     = "CNAME"
}

variable "db_backup_window" {
  description = "30 minute time window to reserve for backups"
  default     = "07:00-07:30" # 12:00AM-12:30AM PT
}

variable "db_maintenance_window" {
  description = "60 minute time window to reserve for maintenance"
  default     = "sun:07:30-sun:08:30" # SUN 12:30AM-01:30AM PT
}

variable "db_apply_immediately" {
  description = "apply changes immediately, which can cause a reboot, so be careful when enabling"
  default     = false
}

variable "db_performance_insights_enabled" {
  description = "boolean to enable/disable performance insights on RDS database"
  default     = false
}

variable "db_performance_insights_kms_key_id" {
  description = "optionally specify KMS key to use for performance insights"
  default     = ""
}

variable "db_performance_insights_retention_period" {
  description = "number of days (min 7) to keep performance insights data"
  default     = 0
}

variable "db_iam_database_authentication_enabled" {
  description = "boolean to enable/disable iam database auth on database instance"
  default     = true
}
