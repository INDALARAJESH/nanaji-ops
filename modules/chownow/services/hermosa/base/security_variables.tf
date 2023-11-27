variable "vpn_subnets" {
  # public ips for pritunl0-ops-west, pritunl1-ops-west, jenkins and jenkins nodes'NAT Gateway IP
  default = ["54.183.225.53/32", "54.183.68.210/32", "52.21.177.104/32", "34.224.187.148/32", "52.6.18.116/32", "54.227.163.228/32"]
}
