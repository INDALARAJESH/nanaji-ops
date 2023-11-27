variable "alb_tcp_port" {
  description = "ALB TCP port to allow incoming connections"
  default     = 443
}

variable "extra_ip_allow_list" {
  description = "a list of additional IPs to allow access to this database"
  default     = []
}
