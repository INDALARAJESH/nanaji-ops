######################
# Database Variables #
######################

variable "db_apply_immediately" {
  description = "boolean to allow parameter changes to be applied immediately"
  default     = true
}

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
  default     = "mysql"
}

variable "db_engine_version" {
  description = "database version"
  default     = "5.7"
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
  default     = true
}

variable "db_vpc_security_group_ids" {
  description = "aws security groups for database"
  default     = []
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
  default     = "3306"
}

variable "db_backup_retention_period" {
  description = "number of days to keep backups and must be greater than 0 for AWS DMS to work"
  default     = 7
}

variable "db_backup_window" {
  description = "30 minute time window to reserve for backups"
  default     = "07:00-07:30" # 12:00AM-12:30AM PT
}

variable "db_maintenance_window" {
  description = "60 minute time window to reserve for maintenance"
  default     = "sun:07:30-sun:08:30" # SUN 12:30AM-01:30AM PT
}

variable "enabled_cloudwatch_logs_exports" {
  description = "enable cloudwatch logs for RDS Instance"
  default     = ["audit", "error"]
}
variable "extra_security_groups" {
  description = "a list of extra security groups to include for this database"
  default     = []
}

variable "performance_insights_enabled" {
  description = "enables performance insights for RDS database"
  default     = true
}

variable "performance_insights_retention_period" {
  description = "performance insights retention period in days"
  default     = 7
}

variable "db_name_suffix" {
  description = "database name suffix for cname record"
  default     = "mysql"
}

variable "dns_record_ttl" {
  description = "TTL for database cname record"
  default     = 900
}

variable "dns_record_type" {
  description = "database record type"
  default     = "CNAME"
}
