variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "numbered instance of the infrastructure. Example: 01"
  default     = ""
}

variable "vpc_name" {
  description = "The name of the VPC that this infrastructure will be created in"
}

variable "create_iam_service_linked_role" {
  description = "Should a linked role be created for es.amazonaws.com"
  default     = false
}

variable "instance_type" {
  description = "Instance type of OpenSearch cluster nodes"
  default     = "t2.medium.elasticsearch"
}

variable "instance_count" {
  description = "Number of OpenSearch cluster nodes to create"
  default     = 3
}

variable "dedicated_master_type" {
  default = ""
}

variable "dedicated_master_count" {
  default = 0
}

variable "service" {
  default = "restaurant-search"
}

variable "ebs_volume_size" {
  description = "Size in GB of EBS volume for each search db node"
  default     = 10
}

variable "dedicated_master_enabled" {
  description = "enable dedicated master mode"
  default     = false
}

locals {
  env         = "${var.env}${var.env_inst}"
  domain_name = "${var.service}-${var.env}${var.env_inst}"
}
