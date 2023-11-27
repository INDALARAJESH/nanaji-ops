variable "vpc_id" {
  description = "VPC ID for security group to attach to"
}

variable "name_prefix" {
  description = "unique name prefix for security group"
}

variable "description" {
  description = "description for security group"
}

variable "ingress_tcp_allowed" {
  description = "list of incoming  TCP ports"
  default     = []
}

variable "ingress_custom_allowed" {
  description = "list of incoming custom ports"
  default     = []
}

variable "ingress_udp_allowed" {
  description = "list of incoming UDP ports"
  default     = []
}

variable "cidr_blocks" {
  description = "a list of allowed ip lists to be paired with ingress tcp/udp allowed variables"
  default     = []
}

variable "enable_egress_allow_all" {
  description = "boolean to enable egress allow all"
  default     = 0
}

variable "ingress_custom_protocol" {
  description = "custom protocol"
  default     = "-1"
}

variable "ingress_custom_self" {
  description = "target self in security group"
  default     = false
}

variable "custom_sg_name" {
  description = "custom security group name"
  default     = ""
}

locals {
  security_group_name = var.custom_sg_name != "" ? var.custom_sg_name : "${var.name_prefix}-${var.service}-${local.env}"
}
