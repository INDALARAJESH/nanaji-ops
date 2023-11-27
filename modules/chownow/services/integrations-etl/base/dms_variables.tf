variable "source_db_instance_identifier" {
  description = "the name/identifier given to the RDS database"
}

variable "database_name" {
  description = "the name of the database that AWS DMS will sync"
  default     = "integrations"

}

#############################
# Source Database Variables #
#############################
variable "source_server_username" {
  description = "source database username"
  default     = "root"
}

#############################
# Target Database Variables #
#############################

variable "target_engine_name" {
  description = "target database engine name"
  default     = "postgres"
}

variable "target_port" {
  description = "target database TCP port"
  default     = 5432
}

variable "target_server_name" {
  description = "target database server name or address"
}

variable "target_username" {
  description = "target database username"
  default     = "dms_target"
}
