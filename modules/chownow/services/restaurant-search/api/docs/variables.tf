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

variable "vpn_ip_addresses" {
  description = "Origin IPs allowed to access documentation"
  default = [
    "54.183.225.53/32",
    "54.183.68.210/32"
  ]
}
