variable "hashkey" {
  description = "hashkey name for the dynamodb table"
  default     = "hashkey"
}

variable "rangekey" {
  description = "rangekey name for the dynamodb table"
  default     = "rangekey"
}

variable "table_name" {
  description = "table name for the dynamodb table"
  default     = "loyalty-dynamodb"
}

variable "read_capacity" {
  description = "Read capacity for dynamodb table"
  default     = "20"
}

variable "write_capacity" {
  description = "Write capacity for dynamodb table"
  default     = "20"
}

locals {
  table_name = "${var.table_name}-${local.env}"
}
