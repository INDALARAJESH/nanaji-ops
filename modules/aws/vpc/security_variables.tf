variable "jenkins_subnets" {
  description = "public ip list for jenkins"
  default     = ["52.21.177.104/32", "34.224.187.148/32"] # jenkins public IP and NAT gateway IP for nodes
}

variable "extra_allowed_subnets" {
  description = "list to allow the addition of extra subnets to have access to this vpc"
  default     = []
}


variable "vpn_ingress_tcp_allowed" {
  default = ["22", "80", "443"]
}


##############
# Cloudflare #
##############

variable "cloudflare_subnets" {
  description = "list of cloudflare subnets/IPs"
  default = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
  ]
}


variable "cloudflare_ingress_tcp_allowed" {
  default = ["443"]
}
