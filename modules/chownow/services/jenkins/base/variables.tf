variable "svpn_dns_zone_name" {
  default = "ops.svpn.chownow.com"
}

variable "env" {
  default = "ops"
}

variable "github_ip_ranges" {
  type        = list(any)
  description = "GitHub IP ranges (https://help.github.com/articles/github-s-ip-addresses/)"
  default     = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20"]
}

variable "alb_name" {
  default = "ops-alb-ops"
}

variable "service" {
  default = "Jenkins"
}

variable "jenkins_ec2_name" {
  default = "jankyns"
}

variable "tag_managed_by" {
  default = "Terraform"
}

locals {
  region         = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id

  common_tags = {
    Environment = var.env
    Service     = var.service
    ManagedBy   = var.tag_managed_by
  }
}
