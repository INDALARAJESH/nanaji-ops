######################
# DB Cluster Variables #
######################

variable "db_cluster_parameter_group_name" {
  description = "parameter group name to use with this cluster"
}

variable "db_database_name" {
  description = "name of database inside cluster"
}

variable "db_instance_class" {
  description = "database instance size"
  default     = "db.t2.small"
}

variable "db_multi_az" {
  description = "boolean for turning on/off multi-az"
  default     = true
}

variable "db_engine" {
  description = "database kind"
  default     = "aurora-mysql"
}

variable "db_engine_mode" {
  description = "database engine mode which will be provisioned or serverless"
  default     = "provisioned"
}

variable "db_engine_version" {
  description = "database version"
  default     = "5.7.mysql_aurora.2.11.3"
}

variable "db_snapshot_identifier" {
  description = "ARN of snapshot you wish to restore from"
  default     = ""
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

variable "db_security_group_ids" {
  description = "additional vpc security groups for database"
  default     = []
}

variable "db_auto_minor_version_upgrade" {
  description = "boolean for allowing automatic minor version upgrades"
  default     = false
}

variable "db_backup_retention_period" {
  description = "database backup retention period"
  default     = 3
}

variable "db_skip_final_snapshot" {
  description = "boolean to skip final snapshot for database"
  default     = true
}

variable "db_username" {
  description = "master database username"
  default     = "root"
}

variable "custom_db_password" {
  description = "override database password during creation (does not apply to snapshot restores)"
  default     = ""
}

variable "db_tcp_port" {
  description = "Ingress database TCP port"
  default     = "3306"
}

variable "db_ca_cert_identifier" {
  description = "database certificate identifier"
  default     = "rds-ca-2019"
}

variable "db_backup_window" {
  description = "30 minute time window to reserve for backups"
  default     = "07:49-08:19" # 12:49AM-1:19AM PT
}

variable "db_maintenance_window" {
  description = "60 minute time window to reserve for maintenance"
  default     = "mon:05:00-mon:06:00" # MON 10:00PM-11:00PM PT
}

variable "cluster_apply_immediately" {
  description = "boolean to allow cluster changes to happen immediately"
  default     = false
}

variable "db_enabled_cloudwatch_logs_exports" {
  description = "list of cloudwatch log exports to enable on cluster"
  default     = ["error", "slowquery", "general"]
}

variable "db_deletion_protection" {
  description = "Enable deletion protection on cluster"
  default     = true
}

variable "db_allow_major_version_upgrade" {
  description = "allow major db version upgrade"
  default     = false
}


#########################
# DB Instance Variables #
#########################

variable "count_cluster_instances" {
  description = "the number of database instances to create in the cluster"
  default     = 2
}

variable "db_apply_immediately" {
  description = "boolean to allow changes to be applied immediately"
  default     = false
}

variable "db_instance_parameter_group_name" {
  description = "parameter group for the instance"
}

variable "db_performance_insights_enabled" {
  description = "boolean to enable/disable performance insights on database instance"
  default     = true
}

variable "db_iam_database_authentication_enabled" {
  description = "boolean to enable/disable iam database auth on database instance"
  default     = true
}

variable "db_enable_monitoring" {
  description = "enables/disables monitoring role creation"
  default     = 1
}

variable "db_monitoring_interval" {
  description = "interval in seconds to monitor database"
  default     = 15
}


######################
# Password Variables #
######################

variable "password_length" {
  description = "character length for randomly generated password"
  default     = 20

}
