variable "vpn_udp_allowed_sources" {
  type        = list(any)
  description = "List of CIDRs allowed for VPN traffic"
  default = [
    "0.0.0.0/0",
  ]
}

