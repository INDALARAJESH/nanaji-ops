variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
  default     = "security"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "aws_org_arn" {
  description = "AWS Organization ARN"
  default     = "arn:aws:organizations::798805100717:organization/o-6uwgjdpwv4"
}

variable "cloudflare_ipv4_name" {
  description = "name given to Cloudflare related resources"
  default     = "cloudflare-public-ipv4"
}

variable "chownow_ipv4_share_name" {
  description = "AWS RAM share name for chownow NAT Gateway IP Prefix lists"
  default     = "chownow-public-ipv4"
}

variable "chownow_ipv4_vpn_ips" {
  description = "List of ChowNow VPN IPs and Jenkins Public IP"
  default = [
    "54.183.225.53/32", # pritunl0-ops-west
    "54.183.68.210/32", # pritunl1-ops-west
    "52.21.177.104/32"  # jenkins
  ]
}

locals {
  env                   = "${var.env}${var.env_inst}"
  chownow_ipv4_vpn_name = "${var.chownow_ipv4_share_name}-vpn"

  common_tags = map(
    "Environment", local.env,
    "ManagedBy", var.tag_managed_by,
    "Service", var.service,
    "ServiceFamily", "Security",
  )
}
