variable "extra_cidr_blocks" {
  description = "extra cidr for ingress"
  default     = []
}

variable "ingress_source_security_group_id" {
  description = "optional security group id for ingress"
  default     = ""
}
