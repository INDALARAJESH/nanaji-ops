variable "name" {
  description = " Name of service"
}

variable "billing_mode" {
  description = "Controls billing for read/write throughput"
  default     = "PROVISIONED"
}

variable "autoscaling_enabled" {
  description = "Controls whether or not to enable autoscaling"
  default     = false
}

variable "autoscale_read_target_value" {
  description = "The target percentage of read units"
  default     = "70"
}

variable "autoscale_min_read_capacity" {
  description = "The min number of read units for this table"
  default     = "20"
}

variable "autoscale_max_read_capacity" {
  description = "The max number of read units for this table"
  default     = "50"
}

variable "autoscale_write_target_value" {
  description = "The target percentage of write units"
  default     = "70"
}

variable "autoscale_min_write_capacity" {
  description = "The min number of write units for this table"
  default     = "20"
}

variable "autoscale_max_write_capacity" {
  description = "The max number of write units for this table"
  default     = "50"
}

variable "hash_key" {
  description = "The name of the hash key in the index "
}

variable "range_key" {
  description = "The name of the range key"
  default     = ""
}

variable "attribute_list" {
  description = "Table attribute list"
  type        = list(object({ name = string, type = string }))
  default     = []
}

variable "enable_streams" {
  description = "Enable log streams"
  default     = true
}

variable "stream_view_type" {
  description = "Stream view type"
  default     = "NEW_AND_OLD_IMAGES"
}

variable "enable_encryption" {
  description = "Enable encryption"
  default     = true
}

variable "enable_point_in_time_recovery" {
  description = "Enable Recovery"
  default     = false
}

variable "ttl_name" {
  description = "Name for TTL"
  default     = ""
}

variable "ttl_enabled" {
  description = "Enable TTL"
  default     = false
}

variable "global_secondary_index" {
  description = "Global secondary index"
  default     = []
}
