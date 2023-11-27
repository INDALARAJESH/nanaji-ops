variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "numbered instance of the infrastructure. Example: 01"
  default     = ""
}

variable "service" {
  description = "name of the service"
  default     = "restaurant-search"
}

locals {
  env = "${var.env}${var.env_inst}"
}
