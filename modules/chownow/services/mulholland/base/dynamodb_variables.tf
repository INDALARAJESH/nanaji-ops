variable "mul_2fa_table_name" {
  description = "unique name"
  default     = "mulholland-2fa"
}

variable "mul_2fa_billing_mode" {
  description = "Controls billing for read/write throughput"
  default     = "PROVISIONED"
}

variable "mul_2fa_read_capacity" {
  description = "The number of write units for this table"
  default     = "5"
}

variable "mul_2fa_write_capacity" {
  description = "The number of read units for this table"
  default     = "5"
}

variable "mul_2fa_hash_key" {
  description = "The hash (partition key) for this table"
  default     = "phone_number"
}

variable "mul_2fa_enable_streams" {
  description = "Enable/Disable dynamo stream for this table"
  default     = false
}

variable "mul_2fa_stream_view_type" {
  description = "Stream type; empty string if enable streams is false"
  default     = ""
}

variable "mul_2fa_attribute_list" {
  description = "Table attribute list"
  type        = list(object({ name = string, type = string }))
  default = [
    {
      name = "phone_number"
      type = "S"
    }
  ]
}

variable "mul_2fa_item_set" {
  type = map(any)
}
