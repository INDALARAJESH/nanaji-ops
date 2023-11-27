############################
# Database Proxy Variables #
############################

variable "target_db_instance" {
  description = "Determines whether DB instance is targeted by proxy"
  type        = bool
  default     = false
}

variable "db_instance_identifier" {
  description = "DB instance identifier"
  type        = string
  default     = ""
}

variable "target_db_cluster" {
  description = "Determines whether DB cluster is targeted by proxy"
  type        = bool
  default     = false
}

variable "db_cluster_identifier" {
  description = "DB cluster identifier"
  type        = string
  default     = ""
}

variable "init_query" {
  description = "One or more SQL statements for the proxy to run when opening each new database connection. Initialization query is not currently supported for PostgreSQL."
  type        = string
  default     = ""
}

variable "add_ro_rw_endpoints" {
  description = "Whether to create additional READ_ONLY and READ_WRITE endpoints for this setup"
  type        = bool
  default     = false
}

variable "max_connections_percent" {
  description = "The maximum size of the connection pool for each target in a target group"
  type        = number
  default     = 90
}

variable "max_idle_connections_percent" {
  description = "Controls how actively the proxy closes idle database connections in the connection pool"
  type        = number
  default     = 50
}

variable "session_pinning_filters" {
  description = "Each item in the list represents a class of SQL operations that normally cause all later statements in a session using a proxy to be pinned to the same underlying database connection"
  type        = list(string)
  default     = []
}

variable "connection_borrow_timeout" {
  description = "The number of seconds for a proxy to wait for a connection to become available in the connection pool"
  type        = number
  default     = null
}

variable "db_debug_logging" {
  description = "Whether the proxy includes detailed information about SQL statements in its logs."
  type        = bool
  default     = false
}

variable "db_engine_family" {
  description = "Valid values are MYSQL and POSTGRESQL. The engine family applies to MySQL and PostgreSQL for both RDS and Aurora"
  type        = string
}

variable "db_idle_client_timeout" {
  description = "The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it."
  type        = number
  default     = 300
}

variable "db_require_tls" {
  description = "Whether Transport Layer Security (TLS) encryption is required for connections to the proxy"
  type        = bool
  default     = true
}

variable "vpc_subnet_ids" {
  description = "One or more VPC subnet IDs to associate with the new proxy."
  type        = list(string)
  default     = []
}

variable "auth_scheme" {
  description = "The type of authentication that the proxy uses for connections from the proxy to the underlying database. One of `SECRETS`"
  type        = string
  default     = "SECRETS"
}

variable "iam_auth" {
  description = "Whether to require or disallow AWS Identity and Access Management (IAM) authentication for connections to the proxy. One of `DISABLED`, `REQUIRED`"
  type        = string
  default     = "DISABLED"
}

variable "secrets" {
  description = "Map of secrets to be used by RDS Proxy for authentication to the database"
  type = map(object({
    arn = string
  }))
}
