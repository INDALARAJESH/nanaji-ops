##############################
# Service Consumer Variables #
##############################

variable "service_consumer_vpc_name" {
  description = "name of service consumer VPC"
}

variable "service_consumer_extra_sg_cidr_blocks" {
  description = "allows additional CIDR blocks to be added to the VPC endpoint"
  default     = []

}
