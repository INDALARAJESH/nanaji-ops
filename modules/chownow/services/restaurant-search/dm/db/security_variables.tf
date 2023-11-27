variable "jenkins_ip_allow_list" {
  description = "a list to allow Jenkins access to this database"
  default     = ["52.21.177.104/32"]
}

variable "extra_ip_allow_list" {
  description = "a list of additional IPs to allow access to this database"
  default     = []
}
