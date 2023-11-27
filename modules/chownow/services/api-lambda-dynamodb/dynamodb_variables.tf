variable "table_name" {
  description = "The table name"
}

variable "billing_mode" {
  description = "Controls billing for read/write throughput"
  default     = "PROVISIONED"
}

variable "read_capacity" {
  description = "The number of write units for this table"
  default     = "20"
}

variable "write_capacity" {
  description = "The number of read units for this table"
  default     = "20"
}

variable "hash_key" {
  description = "The name of the hash key in the index "
}

variable "attribute_list" {
  description = "Table attribute list"
  type        = list(object({ name = string, type = string }))
  default     = []
}

variable "global_secondary_index" {
  description = "Global secondary index attributes for this table"
  default     = []
}
