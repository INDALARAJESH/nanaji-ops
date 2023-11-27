variable "vpc_name_prefix_main" {
  description = "The Main VPC's name prefix, eg. main in main-dev"
  default     = "main"
}

variable "enable_vpce" {
  description = "enable/disable S3 vpce"
  default     = 1
}
