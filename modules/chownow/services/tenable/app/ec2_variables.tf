variable "ingress_tcp_allowed" {
  description = "inbound TCP ports"
  default     = []
}

variable "instance_type" {
  description = "ec2 instance size"
  default     = "m5.xlarge"
}

variable "root_volume_size" {
  description = "root value size"
  default     = 50
}

variable "ami_id" {
  description = "AMI id to use"
  default     = ""
}

variable "enable_dns_record_private" {
  description = "enables/disables private dns zone creation"
  default     = 0
}
