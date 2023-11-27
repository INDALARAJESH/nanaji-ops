##################################
# Replication Instance Variables #
##################################


variable "repl_inst_allocated_storage" {
  description = "replication instance storage"
  default     = 100
}

variable "repl_inst_apply_immediately" {
  description = "enable/disable applying changes to replication instance immediately"
  default     = true
}

variable "repl_inst_auto_minor_version_upgrade" {
  description = "enable/disable applying minor version updates to replication instance"
  default     = true
}

variable "repl_inst_engine_version" {
  description = "AWS DMS replication instance engine version"
  default     = "3.4.6"
}

variable "repl_inst_multi_az" {
  description = "enable/disable multi-az for replication instance"
  default     = true
}

variable "repl_inst_publicly_accessible" {
  description = "enables/disables the replication instance from being publicly accessible"
  default     = false
}

variable "repl_inst_instance_class" {
  description = "replication instance class/size"
  default     = "dms.r4.large"
}

variable "repl_inst_extra_security_groups" {
  description = "additional security group IDs to attach to replication instance"
  default     = []
}


#############################
# Source Database Variables #
#############################

variable "source_database_name" {
  description = "source database name to be replicated"
}

variable "source_engine_name" {
  description = "source database engine name"
}

variable "source_password" {
  description = "source database engine name"
}

variable "source_port" {
  description = "source database engine name"
}

variable "source_server_name" {
  description = "source database server name AKA address"
}

variable "source_ssl_mode" {
  description = "source database SSL mode"
  default     = "none"
}

variable "source_username" {
  description = "source database username"
}

variable "source_extra_connection_attributes" {
  description = "Extra connection attributes"
  default     = ""
}


#############################
# Target Database Variables #
#############################

variable "target_database_name" {
  description = "target database name to be replicated"
}

variable "target_engine_name" {
  description = "target database engine name"
}

variable "target_password" {
  description = "target database engine name"
}

variable "target_port" {
  description = "target database engine name"
}

variable "target_server_name" {
  description = "target database server name AKA address"
}

variable "target_ssl_mode" {
  description = "target database SSL mode"
  default     = "verify-ca"
}

variable "target_username" {
  description = "target database username"
}


##########################
# AWS DMS Task Variables #
##########################

variable "migration_type" {
  description = "the migration type which includes a full sync and continued sync"
  default     = "full-load-and-cdc"
}

variable "table_mappings" {
  description = "json formatted rules for syncing database"
  default     = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
}

variable "repl_task_log_level" {
  description = "DMS logging level set in replication task"
  default     = "LOGGER_SEVERITY_DEFAULT"
}

variable "custom_repl_task_settings" {
  description = "custom replication task settings passed through as json"
  default     = ""
}

variable "repl_instance_deploy_timeout" {
  default = "20m"
}

variable "lob_max_size" {
  description = "Max size in kilobytes of large values. The value should not exceed 102400 based on AWS recommendations https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.TargetMetadata.html"
  default     = 128
}
