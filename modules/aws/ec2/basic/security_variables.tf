variable "ingress_tcp_allowed" {
  description = "list of TCP ports to allow ingress access to the instance(s)"
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "list of CIDR blocks to allow access to instance(s)"
  default     = []
}

variable "enable_egress_allow_all" {
  description = "enables/disables allowing egress for instance(s)"
  default     = 1
}
