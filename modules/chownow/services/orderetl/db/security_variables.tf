variable "vpn_ip_allow_list" {
  description = "a list of VPN IPs to allow access to this database"
  default     = ["54.183.225.53/32", "54.183.68.210/32", "52.21.177.104/32", "52.6.18.116/32", "54.227.163.228/32"]
}

# https://fivetran.com/docs/getting-started/ips
variable "fivetran_ip_allow_list" {
  description = "a list of FiveTran IPs to allow access to this database"
  default     = ["35.234.176.144/29", "52.0.2.4/32", "35.227.135.0/29"]
}

variable "extra_ip_allow_list" {
  description = "a list of additional IPs to allow access to this database"
  default     = []
}
