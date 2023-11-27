variable "source_db_instance_identifier" {
  description = "the name/identifier given to the RDS database"
}

variable "database_name" {
  description = "the name of the database that AWS DMS will sync"
  default     = "chownow"

}

#############################
# Source Database Variables #
#############################
variable "source_server_username" {
  description = "source database username"
  default     = "dms_source"

}

variable "source_engine_name" {
  description = "source database engine name"
  default     = "aurora"

}

#############################
# Target Database Variables #
#############################

variable "target_engine_name" {
  description = "target database engine name"
  default     = "mysql"
}

variable "target_port" {
  description = "target database TCP port"
  default     = 3306
}

variable "target_server_name" {
  description = "target database server name or address"
}

variable "target_username" {
  description = "target database username"
  default     = "dms_target"
}

variable "lob_max_size" {
  description = "Max size in kilobytes of large values. The value should not exceed 102400 based on AWS recommendations https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.TargetMetadata.html"
  default     = 1000
}
