variable "billing_mode" {
  description = "Controls billing for read/write throughput"
  default     = "PAY_PER_REQUEST"
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
  default     = "restaurant_id"
}

variable "attribute_list" {
  description = "Table attribute list"
  type        = list(object({ name = string, type = string }))
  default = [
    {
      name = "restaurant_id"
      type = "S"
    },
    {
      name = "company_id"
      type = "S"
    }
  ]
}

variable "global_secondary_index" {
  description = "Global secondary index attributes for this table"
  default = [
    {
      name               = "company_id_index"
      hash_key           = "company_id"
      range_key          = ""
      write_capacity     = 0 # PAY PER REQUEST
      read_capacity      = 0 # PAY PER REQUEST
      projection_type    = "ALL"
      non_key_attributes = []
    }
  ]
}
