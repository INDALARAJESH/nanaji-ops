variable "source_db_cluster_identifier" {
  description = "the name/identifier given to the RDS database"
}

variable "database_name" {
  description = "the name of the database that AWS DMS will sync"
  default     = "menu"

}

#############################
# Source Database Variables #
#############################
variable "source_server_username" {
  description = "source database username"
  default     = "dms_source"
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
  default     = "root"
}
